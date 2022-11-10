class ChatsController < ApplicationController
  def show
# @userは今回探してきたチャット送られる人
    @user = User.find(params[:id])
#（アソシエーションから）ログインしているカレントユーザーの、
#入っているユーザールームモデルのカラム、ルームidの、レコード配列取得
    rooms = current_user.user_rooms.pluck(:room_id)
#ユーザールームはユーザーidとルームidがカラムとして必要なのでfindby
# カレントユーザーのルーム一覧からチャット送られる人とのルームがあればuser_roomsに格納
#（AさんとBさんに共通のroom_idが存在していれば、その共通のroom_idとBさんのuser_idがuser_room変数に格納される（1レコード）。存在しなければ、nil）
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

# チャットの部屋がない時の条件分岐
  if user_rooms.nil?
    @room = Room.new
    @room.save
    UserRoom.create(user_id: @user.id, room_id: @room.id)
    UserRoom.create(user_id: current_user.id, room_id: @room.id)
  else
    @room = user_rooms.room
  end

    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    # render 'chats/create'
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
  
end
