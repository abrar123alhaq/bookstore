class User < ActiveRecord::Base
  
  validates_length_of :login, :within => 5..20, :message => 'Username must be within 5 to 20 cherectors'
  validates_length_of :password, :within => 6..20, :message => 'Password must be within 5 to 20 cherectors'
  validates_presence_of :login, :on => :create, :message => "can't be blank"
  validates_presence_of :password, :message => "Password can't be blank"
  validates_presence_of :password_confirmation, :message => "Confrm password can't be blank"
  validates_uniqueness_of :login, :message => 'Login must be unique'
  validates_confirmation_of :password, :message => 'Password should match confirmation'
  validates_format_of :email, :with =>  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => 'Email is invalid'
  
  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation

  def self.authenticate(login, pass)
    u=find(:first, :conditions=>["login = ?", login])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  

  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end
