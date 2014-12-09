class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  #Deviseがauthにユーザーのデータをバインディングする前に呼ばれるらしい。
  #だから下でやってるのは、FaceBookからのコールバックが来た時にsessionに追加データが入ってて、
  #なおかつEmailがからじゃなかったらそれを追加してやる、みたいな処理っぽい。
  def self.new_with_session(params, session)
   # super.tap do |user|
   #   if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
   #     user.email = data["email"] if user.email.blank?
   #   end
   # end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.info.nickname,
                         provider:auth.provider,
                         uid:auth.uid,
                         password:Devise.friendly_token[0,20]
                        )
    end
    user
  end
end
