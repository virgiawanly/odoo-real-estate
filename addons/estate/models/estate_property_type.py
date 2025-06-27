from odoo import fields, models


class EstatePropertyType(models.Model):
    _name = "estate.property.type"
    _description = "Estate Property Type"

    name = fields.Char("Name", required=True)

    _sql_constraints = [
        ("check_type_name_unique", "UNIQUE(name)", "Type name must be unique.")
    ]
