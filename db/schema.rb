# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170914145053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chembl_molecule_synonyms", id: :serial, force: :cascade do |t|
    t.integer "molregno"
    t.string "synonym", limit: 200
    t.integer "molsyn_id"
    t.integer "chembl_molecule_id"
    t.string "syn_type", limit: 50
    t.index "clean((synonym)::text)", name: "chembl_molecule_synonyms_index_on_clean_synonym"
    t.index "upper((synonym)::text)", name: "chembl_molecule_synonyms_index_on_upper_synonym"
    t.index "upper(regexp_replace((synonym)::text, '[^\\w]+|_'::text, ''::text))", name: "chembl_molecule_synonyms_index_on_upper_alphanumeric_synonym"
    t.index ["chembl_molecule_id"], name: "index_chembl_molecule_synonyms_on_chembl_molecule_id"
  end

  create_table "chembl_molecules", id: :serial, force: :cascade do |t|
    t.integer "molregno"
    t.string "pref_name", limit: 255
    t.string "chembl_id", limit: 20
    t.integer "max_phase"
    t.boolean "therapeutic_flag"
    t.boolean "dosed_ingredient"
    t.string "structure_type", limit: 10
    t.integer "chebi_par_id"
    t.string "molecule_type", limit: 30
    t.integer "first_approval"
    t.boolean "oral"
    t.boolean "parenteral"
    t.boolean "topical"
    t.boolean "black_box_warning"
    t.boolean "natural_product"
    t.boolean "first_in_class"
    t.integer "chirality"
    t.boolean "prodrug"
    t.boolean "inorganic_flag"
    t.integer "usan_year"
    t.integer "availability_type"
    t.string "usan_stem", limit: 50
    t.boolean "polymer_flag"
    t.string "usan_substem", limit: 50
    t.text "usan_stem_definition"
    t.text "indication_class"
    t.boolean "withdrawn_flag"
    t.integer "withdrawn_year"
    t.text "withdrawn_country"
    t.text "withdrawn_reason"
    t.index "clean((pref_name)::text)", name: "chembl_molecules_index_on_clean_pref_name"
    t.index "upper((pref_name)::text)", name: "chembl_molecules_index_on_upper_pref_name"
    t.index "upper(regexp_replace((pref_name)::text, '[^\\w]+|_'::text, ''::text))", name: "chembl_molecules_index_on_upper_alphanumeric_pref_name"
    t.index ["chembl_id"], name: "index_chembl_molecules_on_chembl_id", unique: true
    t.index ["molregno"], name: "index_chembl_molecules_on_molregno", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "drug_alias_blacklists", force: :cascade do |t|
    t.text "alias"
    t.index ["alias"], name: "index_drug_alias_blacklists_on_alias", unique: true
  end

  create_table "drug_aliases", id: :text, force: :cascade do |t|
    t.text "drug_id", null: false
    t.text "alias", null: false
    t.index "clean(alias)", name: "drug_aliases_index_on_clean_alias"
    t.index "drug_id, upper(alias)", name: "unique_drug_id_alias", unique: true
    t.index "upper(alias)", name: "drug_aliases_index_on_upper_alias"
    t.index "upper(regexp_replace(alias, '[^\\w]+|_'::text, ''::text))", name: "drug_alias_index_on_upper_alphanumeric_alias"
    t.index ["drug_id"], name: "index_drug_aliases_on_drug_id"
  end

  create_table "drug_aliases_sources", primary_key: ["drug_alias_id", "source_id"], force: :cascade do |t|
    t.text "drug_alias_id", null: false
    t.text "source_id", null: false
  end

  create_table "drug_attributes", id: :text, force: :cascade do |t|
    t.text "drug_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index "upper(name)", name: "drug_attributes_index_on_upper_name"
    t.index "upper(value)", name: "drug_attributes_index_on_upper_value"
    t.index ["drug_id", "name", "value"], name: "index_drug_attributes_on_drug_id_and_name_and_value", unique: true
  end

  create_table "drug_attributes_sources", primary_key: ["drug_attribute_id", "source_id"], force: :cascade do |t|
    t.text "drug_attribute_id", null: false
    t.text "source_id", null: false
  end

  create_table "drug_claim_aliases", id: :text, force: :cascade do |t|
    t.text "drug_claim_id", null: false
    t.text "alias", null: false
    t.text "nomenclature", null: false
    t.index "clean(alias)", name: "drug_claim_aliases_index_on_clean_alias"
    t.index "to_tsvector('english'::regconfig, alias)", name: "drug_claim_aliases_full_text", using: :gin
    t.index ["drug_claim_id", "alias", "nomenclature"], name: "unique_drug_claim_aliases", unique: true
    t.index ["drug_claim_id"], name: "drug_claim_aliases_drug_claim_id_idx"
  end

  create_table "drug_claim_attributes", id: :text, force: :cascade do |t|
    t.text "drug_claim_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index ["drug_claim_id", "name", "value"], name: "index_drug_claim_attributes_on_drug_claim_id_and_name_and_value", unique: true
    t.index ["drug_claim_id"], name: "drug_claim_attributes_drug_claim_id_idx"
    t.index ["name"], name: "index_drug_claim_attributes_on_name"
    t.index ["value"], name: "index_drug_claim_attributes_on_value"
  end

  create_table "drug_claim_types", id: :string, limit: 255, force: :cascade do |t|
    t.string "type", limit: 255, null: false
    t.index "lower((type)::text)", name: "drug_claim_types_lower_type_idx"
  end

  create_table "drug_claim_types_drug_claims", primary_key: ["drug_claim_id", "drug_claim_type_id"], force: :cascade do |t|
    t.string "drug_claim_id", limit: 255, null: false
    t.string "drug_claim_type_id", limit: 255, null: false
  end

  create_table "drug_claims", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "nomenclature", null: false
    t.text "source_id"
    t.string "primary_name", limit: 255
    t.text "drug_id"
    t.index "to_tsvector('english'::regconfig, name)", name: "drug_claims_full_text", using: :gin
    t.index ["name", "nomenclature", "source_id"], name: "index_drug_claims_on_name_and_nomenclature_and_source_id", unique: true
    t.index ["source_id"], name: "drug_claims_source_id_idx"
  end

  create_table "drugs", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.boolean "fda_approved"
    t.boolean "immunotherapy"
    t.boolean "anti_neoplastic"
    t.string "chembl_id", null: false
    t.integer "chembl_molecule_id"
    t.index "lower(name)", name: "drugs_lower_name_idx"
    t.index "to_tsvector('english'::regconfig, name)", name: "drugs_full_text", using: :gin
    t.index "upper(name)", name: "drugs_index_on_upper_name"
    t.index ["name"], name: "index_drugs_on_name", unique: true
  end

  create_table "gene_aliases", id: :text, force: :cascade do |t|
    t.text "gene_id", null: false
    t.text "alias", null: false
    t.index "gene_id, upper(alias)", name: "unique_gene_id_alias", unique: true
    t.index "upper(alias)", name: "gene_aliases_index_on_upper_alias"
  end

  create_table "gene_aliases_sources", primary_key: ["gene_alias_id", "source_id"], force: :cascade do |t|
    t.text "gene_alias_id", null: false
    t.text "source_id", null: false
  end

  create_table "gene_attributes", id: :text, force: :cascade do |t|
    t.text "gene_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index ["gene_id", "name", "value"], name: "index_gene_attributes_on_gene_id_and_name_and_value", unique: true
  end

  create_table "gene_attributes_sources", primary_key: ["gene_attribute_id", "source_id"], force: :cascade do |t|
    t.text "gene_attribute_id", null: false
    t.text "source_id", null: false
  end

  create_table "gene_categories_genes", primary_key: ["gene_claim_category_id", "gene_id"], force: :cascade do |t|
    t.text "gene_claim_category_id", null: false
    t.text "gene_id", null: false
  end

  create_table "gene_claim_aliases", id: :text, force: :cascade do |t|
    t.text "gene_claim_id", null: false
    t.text "alias", null: false
    t.text "nomenclature", null: false
    t.index "lower(alias)", name: "gene_claim_aliases_lower_alias_idx"
    t.index "to_tsvector('english'::regconfig, alias)", name: "gene_claim_aliases_full_text", using: :gin
    t.index ["alias"], name: "index_gene_claim_aliases_on_alias"
    t.index ["gene_claim_id", "alias", "nomenclature"], name: "unique_gene_claim_aliases", unique: true
    t.index ["gene_claim_id"], name: "gene_claim_aliases_gene_claim_id_idx"
  end

  create_table "gene_claim_attributes", id: :text, force: :cascade do |t|
    t.text "gene_claim_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index ["gene_claim_id", "name", "value"], name: "index_gene_claim_attributes_on_gene_claim_id_and_name_and_value", unique: true
    t.index ["gene_claim_id"], name: "gene_claim_attributes_gene_claim_id_idx"
    t.index ["name"], name: "index_gene_claim_attributes_on_name"
    t.index ["value"], name: "index_gene_claim_attributes_on_value"
  end

  create_table "gene_claim_categories", id: :string, limit: 255, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.index "lower((name)::text)", name: "gene_claim_categories_lower_name_idx"
  end

  create_table "gene_claim_categories_gene_claims", primary_key: ["gene_claim_id", "gene_claim_category_id"], force: :cascade do |t|
    t.string "gene_claim_id", limit: 255, null: false
    t.string "gene_claim_category_id", limit: 255, null: false
  end

  create_table "gene_claims", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "nomenclature", null: false
    t.text "source_id"
    t.text "gene_id"
    t.index "to_tsvector('english'::regconfig, name)", name: "gene_claims_full_text", using: :gin
    t.index ["name", "nomenclature", "source_id"], name: "index_gene_claims_on_name_and_nomenclature_and_source_id", unique: true
    t.index ["name"], name: "index_gene_claims_on_name"
    t.index ["source_id"], name: "gene_claims_source_id_idx"
  end

  create_table "gene_gene_interaction_claim_attributes", primary_key: "gene_gene_interaction_claim_id", id: :string, limit: 255, force: :cascade do |t|
    t.string "id", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.string "value", limit: 255, null: false
  end

  create_table "gene_gene_interaction_claims", id: :string, limit: 255, force: :cascade do |t|
    t.string "gene_id", limit: 255, null: false
    t.string "interacting_gene_id", limit: 255, null: false
    t.string "source_id", limit: 255, null: false
    t.index ["gene_id", "interacting_gene_id"], name: "left_and_interacting_gene_interaction_index"
    t.index ["gene_id"], name: "index_gene_gene_interaction_claims_on_gene_id"
    t.index ["interacting_gene_id"], name: "index_gene_gene_interaction_claims_on_interacting_gene_id"
  end

  create_table "genes", id: :text, force: :cascade do |t|
    t.text "name"
    t.string "long_name", limit: 255
    t.integer "entrez_id"
    t.index "to_tsvector('english'::regconfig, name)", name: "genes_full_text", using: :gin
    t.index "upper((long_name)::text)", name: "genes_index_on_upper_long_name"
    t.index "upper(name)", name: "genes_index_on_upper_name"
    t.index ["entrez_id"], name: "index_genes_on_entrez_id"
  end

  create_table "interaction_attributes", id: :text, force: :cascade do |t|
    t.text "interaction_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index ["interaction_id", "name", "value"], name: "unique_interaction_attributes", unique: true
  end

  create_table "interaction_attributes_sources", primary_key: ["interaction_attribute_id", "source_id"], force: :cascade do |t|
    t.text "interaction_attribute_id", null: false
    t.text "source_id", null: false
  end

  create_table "interaction_claim_attributes", id: :text, force: :cascade do |t|
    t.text "interaction_claim_id", null: false
    t.text "name", null: false
    t.text "value", null: false
    t.index ["interaction_claim_id", "name", "value"], name: "unique_interaction_claim_attributes", unique: true
    t.index ["interaction_claim_id"], name: "interaction_claim_attributes_interaction_claim_id_idx"
  end

  create_table "interaction_claim_types", id: :string, limit: 255, force: :cascade do |t|
    t.string "type", limit: 255
    t.index "lower((type)::text)", name: "interaction_claim_types_lower_type_idx"
  end

  create_table "interaction_claim_types_interaction_claims", primary_key: ["interaction_claim_type_id", "interaction_claim_id"], force: :cascade do |t|
    t.string "interaction_claim_type_id", limit: 255, null: false
    t.string "interaction_claim_id", limit: 255, null: false
  end

  create_table "interaction_claims", id: :text, force: :cascade do |t|
    t.text "drug_claim_id", null: false
    t.text "gene_claim_id", null: false
    t.text "source_id"
    t.text "interaction_id"
    t.index ["drug_claim_id", "gene_claim_id", "source_id"], name: "unique_interaction_claims", unique: true
    t.index ["drug_claim_id"], name: "interaction_claims_drug_claim_id_idx"
    t.index ["gene_claim_id"], name: "interaction_claims_gene_claim_id_idx"
    t.index ["source_id"], name: "interaction_claims_source_id_idx"
  end

  create_table "interaction_claims_publications", primary_key: ["interaction_claim_id", "publication_id"], force: :cascade do |t|
    t.text "interaction_claim_id", null: false
    t.text "publication_id", null: false
  end

  create_table "interaction_types_interactions", primary_key: ["interaction_claim_type_id", "interaction_id"], force: :cascade do |t|
    t.text "interaction_claim_type_id", null: false
    t.text "interaction_id", null: false
  end

  create_table "interactions", id: :text, force: :cascade do |t|
    t.text "drug_id", null: false
    t.text "gene_id", null: false
    t.index ["drug_id", "gene_id"], name: "index_interactions_on_drug_id_and_gene_id", unique: true
  end

  create_table "interactions_publications", primary_key: ["interaction_id", "publication_id"], force: :cascade do |t|
    t.text "interaction_id", null: false
    t.text "publication_id", null: false
  end

  create_table "interactions_sources", primary_key: ["interaction_id", "source_id"], force: :cascade do |t|
    t.text "interaction_id", null: false
    t.text "source_id", null: false
  end

  create_table "publications", id: :text, force: :cascade do |t|
    t.integer "pmid", null: false
    t.text "citation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["pmid"], name: "index_publications_on_pmid", unique: true
  end

  create_table "source_trust_levels", id: :string, limit: 255, force: :cascade do |t|
    t.string "level", limit: 255, null: false
    t.index "lower((level)::text)", name: "source_trust_levels_lower_level_idx"
  end

  create_table "source_types", id: :string, limit: 255, force: :cascade do |t|
    t.string "type", limit: 255, null: false
    t.string "display_name", limit: 255
  end

  create_table "sources", id: :text, force: :cascade do |t|
    t.text "source_db_name", null: false
    t.text "source_db_version", null: false
    t.text "citation"
    t.text "base_url"
    t.text "site_url"
    t.text "full_name"
    t.string "source_type_id", limit: 255
    t.integer "gene_claims_count", default: 0
    t.integer "drug_claims_count", default: 0
    t.integer "interaction_claims_count", default: 0
    t.integer "interaction_claims_in_groups_count", default: 0
    t.integer "gene_claims_in_groups_count", default: 0
    t.integer "drug_claims_in_groups_count", default: 0
    t.string "source_trust_level_id", limit: 255
    t.integer "gene_gene_interaction_claims_count", default: 0
    t.index "lower(source_db_name)", name: "sources_lower_source_db_name_idx"
    t.index ["source_trust_level_id"], name: "sources_source_trust_level_id_idx"
    t.index ["source_type_id"], name: "sources_source_type_id_idx"
  end

  add_foreign_key "drug_aliases", "drugs", on_delete: :cascade
  add_foreign_key "drug_aliases_sources", "drug_aliases", name: "fk_drug_alias"
  add_foreign_key "drug_aliases_sources", "sources", name: "fk_source"
  add_foreign_key "drug_attributes", "drugs", name: "fk_drug"
  add_foreign_key "drug_attributes_sources", "drug_attributes", name: "fk_drug_attribute"
  add_foreign_key "drug_attributes_sources", "sources", name: "fk_source"
  add_foreign_key "drug_claim_aliases", "drug_claims", name: "fk_drug_claim_id"
  add_foreign_key "drug_claim_attributes", "drug_claims", name: "fk_drug_claim_id"
  add_foreign_key "drug_claim_types_drug_claims", "drug_claim_types", name: "fk_drug_claim_type"
  add_foreign_key "drug_claim_types_drug_claims", "drug_claims", name: "fk_drug_claim"
  add_foreign_key "drug_claims", "drugs", name: "fk_drug"
  add_foreign_key "drug_claims", "sources", name: "fk_source_id"
  add_foreign_key "drugs", "chembl_molecules"
  add_foreign_key "gene_aliases", "genes", name: "fk_gene"
  add_foreign_key "gene_aliases_sources", "gene_aliases", name: "fk_gene_alias"
  add_foreign_key "gene_aliases_sources", "sources", name: "fk_source"
  add_foreign_key "gene_attributes", "genes", name: "fk_gene"
  add_foreign_key "gene_attributes_sources", "gene_attributes", name: "fk_gene_attribute"
  add_foreign_key "gene_attributes_sources", "sources", name: "fk_source"
  add_foreign_key "gene_categories_genes", "gene_claim_categories", name: "fk_gene_claim_category"
  add_foreign_key "gene_categories_genes", "genes", name: "fk_gene"
  add_foreign_key "gene_claim_aliases", "gene_claims", name: "fk_gene_claim_id"
  add_foreign_key "gene_claim_attributes", "gene_claims", name: "fk_gene_claim_id"
  add_foreign_key "gene_claim_categories_gene_claims", "gene_claim_categories", name: "fk_gene_claim_category"
  add_foreign_key "gene_claim_categories_gene_claims", "gene_claims", name: "fk_gene_claim"
  add_foreign_key "gene_claims", "genes", name: "fk_gene"
  add_foreign_key "gene_claims", "sources", name: "fk_source_id"
  add_foreign_key "gene_gene_interaction_claim_attributes", "gene_gene_interaction_claims", name: "fk_attributes_gene_interaction_claim"
  add_foreign_key "gene_gene_interaction_claims", "genes", column: "interacting_gene_id", name: "fk_gene_interaction_claims_interacting_gene"
  add_foreign_key "gene_gene_interaction_claims", "genes", name: "fk_gene_interaction_claims_gene"
  add_foreign_key "gene_gene_interaction_claims", "sources", name: "fk_gene_interaction_claims_sources"
  add_foreign_key "interaction_attributes", "interactions", on_delete: :cascade
  add_foreign_key "interaction_attributes_sources", "interaction_attributes", name: "fk_interaction_attribute"
  add_foreign_key "interaction_attributes_sources", "sources", name: "fk_source"
  add_foreign_key "interaction_claim_attributes", "interaction_claims", name: "fk_interaction_claim_id"
  add_foreign_key "interaction_claim_types_interaction_claims", "interaction_claim_types", name: "fk_interaction_claim_type"
  add_foreign_key "interaction_claim_types_interaction_claims", "interaction_claims", name: "fk_interaction_claim"
  add_foreign_key "interaction_claims", "drug_claims", name: "fk_drug_claim_id"
  add_foreign_key "interaction_claims", "gene_claims", name: "fk_gene_claim_id"
  add_foreign_key "interaction_claims", "interactions", name: "fk_interaction"
  add_foreign_key "interaction_claims", "sources", name: "fk_source_id"
  add_foreign_key "interaction_claims_publications", "interaction_claims", name: "fk_interaction_claim"
  add_foreign_key "interaction_claims_publications", "publications", name: "fk_publication"
  add_foreign_key "interaction_types_interactions", "interaction_claim_types", name: "fk_interaction_type"
  add_foreign_key "interaction_types_interactions", "interactions", name: "fk_interaction"
  add_foreign_key "interactions", "drugs", name: "fk_drug"
  add_foreign_key "interactions", "genes", name: "fk_gene"
  add_foreign_key "interactions_publications", "interactions", name: "fk_interaction"
  add_foreign_key "interactions_publications", "publications", name: "fk_publication"
  add_foreign_key "interactions_sources", "interactions", name: "fk_interaction"
  add_foreign_key "interactions_sources", "sources", name: "fk_source"
  add_foreign_key "sources", "source_trust_levels", name: "fk_source_trust_level"
  add_foreign_key "sources", "source_types", name: "fk_source_type"
end
