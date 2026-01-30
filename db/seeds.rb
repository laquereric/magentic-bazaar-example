# Create default admin user
admin = User.find_or_initialize_by(email_address: "admin@example.com")
admin.update!(
  name: "Admin",
  password: "password123",
  password_confirmation: "password123",
  admin: true
)
puts "Admin user created: admin@example.com / password123"
