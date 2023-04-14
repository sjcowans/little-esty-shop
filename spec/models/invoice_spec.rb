require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class method' do
    it 'can create a custom date' do
      @customer_1 = Customer.create!(first_name: 'Jon', last_name: 'Jones')
      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09 UTC')
      
      expect(@invoice_1.custom_date).to eq("Sunday, March 25, 2012")
    end
  end

  describe 'instance methods' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: 'Etsy')
      @item_1 = @merchant_1.items.create!(name: 'Axe', description: 'Chop stuff', unit_price: 1000)
      @item_2 = @merchant_1.items.create!(name: 'Hammer', description: 'Hit stuff', unit_price: 1500)
      @customer_1 = Customer.create!(first_name: 'Jon', last_name: 'Jones')
      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: '2012-03-25')
      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id)
      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id)
      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id)
    end
    
    # describe '.item_name' do
    #   it 'returns the name of the item within given invoice' do
    #     expect(@item_1.name).to eq('Axe')
    #     expect(@item_2.item_name).to eq('Hammer')
    #   end
    # end

    describe '.item_quantity' do
      it 'returns the quantity of items within given invoice' do
        expect(@invoice_1.item_quantity(@item_1)).to eq(3)
        expect(@invoice_1.item_quantity(@item_2)).to eq(1)
      end
    end
  end
end