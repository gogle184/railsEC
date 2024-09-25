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
      email: 'Bob@example.com',
      password: 'password',
      password_confirmation: 'password',
      display_name: 'Bob',
      name: 'BobWatanabe',
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
