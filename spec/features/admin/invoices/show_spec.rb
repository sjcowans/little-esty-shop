require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page', type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Etsy')
    @item_1 = @merchant_1.items.create!(name: 'Axe', description: 'Chop stuff', unit_price: 1000)
    @customer_1 = Customer.create!(first_name: 'Will', last_name: 'Rogers')
    @customer_2 = Customer.create!(first_name: 'Carl', last_name: 'Weathers')
    @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: '2012-03-25')
    @invoice_2 = @customer_2.invoices.create!(status: 0, created_at: '2012-03-24')
    @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '2012-03-27', result: 1)
    @transaction_2 = @invoice_2.transactions.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '2012-03-27', result: 1)
    InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id) 
    InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id) 
  end
  
  describe 'As an Admin, When I visit the admin invoice show page' do
    describe 'I see information related to that invoice including:' do
      it 'Invoice id, status, created_at date, and customer name' do 
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content("Status: completed")
        expect(page).to have_content("Created At: Sunday, March 25, 2012")
        expect(page).to have_content("Customer Name: Will Rogers")
        
        visit admin_invoice_path(@invoice_2)
        expect(page).to have_content(@invoice_2.id)
        expect(page).to have_content("Status: in_progress")
        expect(page).to have_content("Created At: Saturday, March 24, 2012")
        expect(page).to have_content("Customer Name: Carl Weathers")
      end
    end
    describe 'item section for admin invoice show' do
      it 'displays the item name' do
        visit "admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@item_1.name)
      end

      it 'displays the quantity of the item ordered' do
        visit "admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content("Quantity: 2")
      end

      it 'displays the price of the item sold for' do
        visit "admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@item_1.unit_price)
        expect(page).to have_content("Price: 1000")
      end

      it 'displays the invoice item status' do
        visit "admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content(@item_1.status)
      end

      it 'displays the total revenue that will be generated from this invoice' do
        visit "admin/invoices/#{@invoice_1.id}"

        expect(page).to have_content("Total Revenue: 1000")
      end
    end

    describe 'Invoice Status Update' do
      it "has a form to update the invoice status by selecting new status and clicking submit.
        I am taken back to show page and see updated invoice status" do
        visit admin_invoice_path(@invoice_1)
        within "#invoice-status" do
          expect(page).to have_select("invoice[status]", selected: "completed") 
          select('in_progress', from:'invoice_status')
          click_on 'Update'
          expect(current_path).to eq(admin_invoice_path(@invoice_1))
          expect(page).to have_content("Status: in_progress")
          select('completed', from:'invoice_status')
          click_on 'Update'
          expect(page).to have_content("Status: completed")
        end

        visit admin_invoice_path(@invoice_2)
        within "#invoice-status" do
          expect(page).to have_select("invoice[status]", selected: "in_progress")
          select('cancelled', from:'invoice_status')
          click_on 'Update'
          expect(current_path).to eq(admin_invoice_path(@invoice_2))
          expect(page).to have_content("Status: cancelled")
        end
      end
    end
  end
end