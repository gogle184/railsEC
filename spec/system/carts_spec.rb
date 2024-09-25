require 'rails_helper'

RSpec.describe 'Carts', type: :system do
  context '非ログイン時' do
    describe '追加' do
      it 'カートに商品を追加できること' do
        product = create(:product, name: '商品A', price: 200)

        visit product_path(product)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        expect(page).to have_content 'カートアイテムを登録しました'
        expect(page).to have_content '商品A'
        expect(page).to have_content '220円'
        expect(page).to have_content '3'
        expect(page).to have_button '点数を更新'
        expect(page).to have_button '削除'
        expect(page).to have_content '合計点数 3'
        expect(page).to have_content '小計 660円'
        expect(page).to have_content '代引手数料 330円'
        expect(page).to have_content '送料 660円'
        expect(page).to have_content '合計請求金額 1,650円'
        expect(page).to have_link '購入するにはログインしてください', href: new_user_session_path
      end

      it '既にカートに入っている商品を追加すると、カートアイテムの数量が加算されること' do
        product = create(:product, name: '商品A')

        visit product_path(product)
        fill_in 'cart_item[quantity]', with: 2
        click_on 'カートに入れる'
        visit product_path(product)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        expect(page).to have_content '合計点数 5'
      end
    end

    describe '照会' do
      it 'カートが空の場合、空であることを表示すること' do
        visit cart_path

        expect(page).to have_content 'カートは空です'
      end

      it '商品がカートにある場合、カートの中身を確認できること' do
        product_in_cart = create(:product, name: 'カートに入れる商品')
        create(:product, name: 'カートに入れない商品')

        visit product_path(product_in_cart)
        click_on 'カートに入れる'

        expect(page).to have_current_path cart_path
        expect(page).to have_content 'カートに入れる商品'
        expect(page).not_to have_content 'カートに入れない商品'
        expect(page).not_to have_content '購入手続きに進む'
      end
    end

    describe '更新' do
      it '商品ごとの数量を変更できること' do
        product_in_cart = create(:product, name: '商品A')

        visit product_path(product_in_cart)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        expect(page).to have_content '合計点数 3'
        expect(page).to have_current_path cart_path
        fill_in 'cart_item[quantity]', with: 1
        click_on '点数を更新'

        expect(page).to have_content 'カートアイテムを更新しました'
        expect(page).to have_content '合計点数 1'
      end
    end

    describe '削除' do
      it '商品を削除できること' do
        product_to_remove = create(:product, name: '消える商品')
        product_to_keep = create(:product, name: '残る商品')

        visit product_path(product_to_remove)
        click_on 'カートに入れる'
        visit product_path(product_to_keep)
        click_on 'カートに入れる'
        within('.col-md-7', text: '消える商品') do
          click_on 'カートから削除'
        end

        expect(page).to have_content 'カートアイテムを削除しました'
        expect(page).to have_content '残る商品'
        expect(page).not_to have_content '消える商品'
      end
    end

    describe 'セッション〜ログイン' do
      it 'ログイン時、セッションに保存されていたカートがユーザーのカートに統合されること' do
        user = create(:user)
        session_product = create(:product, name: 'セッションの商品')
        user_product = create(:product, name: 'ユーザーの商品')
        cart = create(:cart, user:, cart_items: [create(:cart_item, product: user_product, quantity: 2)])
        create(:cart_item, cart:, product: session_product, quantity: 2)

        visit product_path(session_product)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        sign_in user
        visit cart_path

        expect(page).to have_content 'セッションの商品'
        within('.col-md-7', text: 'セッションの商品') do
          expect(find('input#cart_item_quantity').value).to eq '5'
        end
        expect(page).to have_content 'ユーザーの商品'
        within('.col-md-7', text: 'ユーザーの商品') do
          expect(find('input#cart_item_quantity').value).to eq '2'
        end
        expect(page).to have_content '合計点数 7'
      end
    end
  end

  context 'ログイン時' do
    let(:user) { create(:user) }
    let(:first_product) { create(:product, name: '商品A', price: 200) }
    let(:second_product) { create(:product, name: '商品B', price: 300) }

    before do
      sign_in user
    end

    describe '追加' do
      it 'カートに商品を追加できること' do
        visit product_path(first_product)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        expect(page).to have_content 'カートアイテムを登録しました'
        expect(page).to have_content '商品A'
        expect(page).to have_content '220円'
        expect(page).to have_content '3'
        expect(page).to have_button '点数を更新'
        expect(page).to have_button '削除'
        expect(page).to have_content '合計点数 3'
        expect(page).to have_content '小計 660円'
        expect(page).to have_content '代引手数料 330円'
        expect(page).to have_content '送料 660円'
        expect(page).to have_content '合計請求金額 1,650円'
        expect(page).to have_content '購入手続きに進む'
      end

      it '既にカートに入っている商品を追加すると、カートアイテムの数量が加算されること' do
        visit product_path(first_product)
        fill_in 'cart_item[quantity]', with: 2
        click_on 'カートに入れる'
        visit product_path(first_product)
        fill_in 'cart_item[quantity]', with: 3
        click_on 'カートに入れる'

        expect(page).to have_content '合計点数 5'
      end
    end

    describe '照会' do
      it 'カートが空の場合、空であることを表示すること' do
        visit cart_path

        expect(page).to have_content 'カートは空です'
      end

      it 'カートの中身を確認できること' do
        cart = create(:cart, user:)
        create(:cart_item, cart:, product: first_product, quantity: 2)
        create(:product, name: 'カートに入れない商品')

        visit cart_path
        expect(page).to have_content '商品A'
        expect(page).not_to have_content 'カートに入れない商品'
        expect(page).to have_content '購入手続きに進む'
      end
    end

    describe '更新' do
      it '商品ごとの数量を変更できること' do
        cart = create(:cart, user:)
        create(:cart_item, cart:, product: first_product, quantity: 2)

        visit cart_path
        expect(page).to have_content '合計点数 2'
        fill_in 'cart_item[quantity]', with: 1
        click_on '点数を更新'

        expect(page).to have_content 'カートアイテムを更新しました'
        expect(page).to have_content '合計点数 1'
      end
    end

    describe '削除' do
      it '商品を削除できること' do
        cart = create(:cart, user:)
        create(:cart_item, cart:, product: first_product, quantity: 2)
        create(:cart_item, cart:, product: second_product, quantity: 3)

        visit cart_path
        within('.col-md-7', text: '商品A') do
          click_on 'カートから削除'
        end

        expect(page).to have_content 'カートアイテムを削除しました'
        expect(page).to have_content '商品B'
        expect(page).not_to have_content '商品A'
      end
    end
  end
end
