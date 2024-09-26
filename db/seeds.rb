Admin.create!(
  [
    {
      email: 'admin1@example.com',
      password: 'password',
      password_confirmation: 'password',
    },
  ]
)

User.create!(
  [
    {
      email: 'alice@example.com',
      password: 'password',
      password_confirmation: 'password',
      display_name: 'Alice',
      name: 'AliceSato',
      phone_number: '09012345678',
      postal_code: '1234567',
      address: '東京都渋谷区',
    },
    {
      email: 'bob@example.com',
      password: 'password',
      password_confirmation: 'password',
      display_name: 'Bob',
      name: 'BobWatanabe',
      phone_number: '08098765432',
      postal_code: '7654321',
      address: '神奈川県横浜市',
    },
    {
      email: 'charlie@example.com',
      password: 'password',
      password_confirmation: 'password',
      display_name: 'チャーリー',
      name: '伊藤チャーリー',
      phone_number: '08098765432',
      postal_code: '7654321',
      address: '神奈川県横浜市',
    },
  ]
)

Product.create!(
  [
    {
      name: 'りんご',
      price: 300,
      description: 'ここは説明',
      display: true,
    },
    {
      name: 'ばなな',
      price: 1000,
      description: 'ここは説明',
      display: true,
    },
    {
      name: 'ぶどう',
      price: 300,
      description: 'ここは説明',
      display: true,
    },
    {
      name: '山椒',
      price: 300,
      description: 'ここは説明',
      display: true,
    },
    {
      name: 'もも',
      price: 300,
      description: 'ここは説明',
      display: false,
    },
  ]
)

diaries = Diary.create!([
  { user: User.first, title: 'Aliceの日記1', content: '今日はいい天気でした。公園に行きました。', display: true },
  { user: User.first, title: 'Aliceの日記2', content: '新しいカフェを見つけました。', display: true },
  { user: User.second, title: 'Bobの日記1', content: '最近はプログラミングを勉強しています。', display: true },
  { user: User.second, title: 'Bobの日記2', content: '週末にキャンプに行きました。', display: true },
  { user: User.third, title: 'Charlieの日記1', content: '初めての登山に挑戦しました。', display: true }
])

comments = Comment.create!([
  { user: User.second, diary: diaries[0], content: 'とても楽しい日記ですね！' },
  { user: User.third, diary: diaries[1], content: 'カフェの名前を教えてください！' },
  { user: User.first, diary: diaries[2], content: 'プログラミングは面白いですよね。' },
  { user: User.third, diary: diaries[3], content: 'キャンプはどこで行いましたか？' },
  { user: User.second, diary: diaries[4], content: '登山の詳細を聞かせてください！' }
])

Favorite.create!([
  { user: User.first, diary: diaries[1] },
  { user: User.first, diary: diaries[2] },
  { user: User.second, diary: diaries[0] },
  { user: User.second, diary: diaries[3] },
  { user: User.third, diary: diaries[0] },
  { user: User.third, diary: diaries[1] }
])
