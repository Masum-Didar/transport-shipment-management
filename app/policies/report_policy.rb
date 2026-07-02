class ReportPolicy < ApplicationPolicy
  def daily?        = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
  def weekly?       = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
  def monthly?      = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
  def truck_wise?   = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
  def driver_wise?  = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
  def product_wise? = user.role.name.in?(%w[super_admin admin dispatcher account viewer])
end
