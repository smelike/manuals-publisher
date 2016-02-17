class TribunalDecisionSubCategoryRelatesToParentValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, sub_category)
    if sub_category.present?
      validate_sub_category(record, attribute, sub_category)
    else
      validate_sub_category_present_if_parent_has_sub_categories(record, attribute)
    end
  end

  private

  def validate_sub_category_present_if_parent_has_sub_categories(record, attribute)
    if record.tribunal_decision_category.present? && category_has_sub_categories?(record)
      record.errors.add attribute, "must not be blank"
    end
  end

  def category_has_sub_categories?(record)
    prefix = category_prefix(record)
    sub_category_allowed_values(record).any? do
      |sub_category| sub_category[/^#{prefix}/]
    end
  end

  def sub_category_allowed_values(record)
    sub_category_options = FinderSchema.options_for(:tribunal_decision_sub_category, type(record))
    sub_category_options.map(&:last)
  end

  def validate_sub_category(record, attribute, sub_category)
    if sub_category.size > 1
      record.errors.add attribute, "change to a single sub-category"
    elsif !prefixed_by_parent_category?(sub_category.first, record)
      message = if category_has_sub_categories?(record)
                  "change to be a sub-category of '#{category_label(record)}' or change category"
                else
                  "remove sub-category as '#{category_label(record)}' category has no sub-categories"
                end
      record.errors.add attribute, message
    end
  end

  private

  def category_prefix(record)
    category = record.tribunal_decision_category
    prefix = category
    if record.respond_to?(:category_prefix_for)
      category_prefix = record.category_prefix_for(category)
      prefix = category_prefix if category_prefix.present?
    end
    prefix
  end

  def prefixed_by_parent_category?(sub_category, record)
    prefix = category_prefix(record)
    sub_category[/^#{prefix}/]
  end

  def category_label(record)
    labels = FinderSchema.humanized_facet_name(:tribunal_decision_category, record, type(record))
    labels.first
  end

  def type(record)
    record.class.name.underscore
  end
end
