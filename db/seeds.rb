Admin.create!(
  [
    {
      email: 'admin1@example.com',
      password: 'password',
      password_confirmation: 'password',
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
