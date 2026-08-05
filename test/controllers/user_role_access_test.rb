require "test_helper"

class UserRoleAccessTest < ActionDispatch::IntegrationTest
  setup do
    @user_role = Role.find_or_create_by!(name: "user")
    @admin_role = Role.find_or_create_by!(name: "admin")
    @location = create(:location)
    @user = create(:user, role: @user_role, status: "active", email: "access-#{SecureRandom.hex(4)}@example.com")
  end

  test "user can access new truck page" do
    sign_in @user
    get new_truck_path
    assert_response :success
  end

  test "user can create a truck" do
    sign_in @user
    assert_difference "Truck.count", 1 do
      post trucks_path, params: {
        truck: { truck_number: "DHK-#{SecureRandom.hex(4).upcase}", truck_type: "company", brand: "Tata",
                 vehicle_model: "LPK", year: 2022, capacity_kg: 15000, status: "available", current_location_id: @location.id }
      }
    end
    assert_redirected_to truck_path(Truck.last)
  end

  test "user can create a driver" do
    sign_in @user
    assert_difference "Driver.count", 1 do
      post drivers_path, params: {
        driver: { name: "Test Driver", phone: "01#{rand(10**9..10**10)}" }
      }
    end
  end

  test "user can create a location" do
    sign_in @user
    assert_difference "Location.count", 1 do
      post locations_path, params: {
        location: { name: "Test Location #{SecureRandom.hex(4)}", location_type: "warehouse", city: "Dhaka", country: "Bangladesh" }
      }
    end
  end

  test "user can create a product" do
    category = create(:product_category)
    sign_in @user
    assert_difference "Product.count", 1 do
      post products_path, params: {
        product: { name: "Test Product #{SecureRandom.hex(4)}", product_category_id: category.id, default_unit: "kg" }
      }
    end
  end

  test "user can create a shipment" do
    sign_in @user
    assert_difference "Shipment.count", 1 do
      post shipments_path, params: {
        shipment: {
          shipment_number: "SH-#{SecureRandom.hex(4).upcase}",
          shipment_type: "export",
          source_location_id: @location.id,
          destination_location_id: @location.id,
          shipment_date: Date.today
        }
      }
    end
  end

  test "user cannot destroy a truck" do
    truck = create(:truck)
    sign_in @user
    delete truck_path(truck, locale: I18n.locale)
    assert_redirected_to root_path
    assert truck.reload.persisted?
  end
end
