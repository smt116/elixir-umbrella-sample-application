alias Core.{
  Accounts,
  Feed,
}

{:ok, john} =
  Accounts.create_user(
    %{
      email: "john@example.com",
      first_name: "John",
      last_name: "Doe",
      password: "secret"
    }
  )

{:ok, susan} =
  Accounts.create_user(
    %{
      email: "susan@example.com",
      first_name: "Susan",
      last_name: "Doe",
      password: "secret"
    }
  )

Stream.map(
  [
    {john, "Don't cry because it's over, smile because it happened. ― Dr. Seuss"},
    {susan, "I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best. ― Marilyn Monroe"},
    {john, "Be yourself; everyone else is already taken. ― Oscar Wilde"},
    {john, "Two things are infinite: the universe and human stupidity; and I'm not sure about the universe. ― Albert Einstein"},
    {susan, "So many books, so little time. ― Frank Zappa"},
    {susan, "Be who you are and say what you feel, because those who mind don't matter, and those who matter don't mind. ― Bernard M. Baruch"},
    {john, "A room without books is like a body without a soul. ― Marcus Tullius Cicero"}
  ], fn {user, text} -> %{user_id: user.id, text: text} end)
|> Enum.each(&Feed.create_post/1)
