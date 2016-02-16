class ManualPresenter

  def initialize(manual)
    @manual = manual
  end

  def to_json
    {
      content_id: manual.content_id,
      base_path: manual.base_path,
      title: manual.title,
      description: manual.summary,
      format: "manual",
      publishing_app: "specialist-publisher",
      rendering_app: "specialist-frontend",
      locale: "en",
      phase: "live",
      public_updated_at: public_updated_at,
      details: {
        body: manual.body,
        child_section_groups: {
          title: "Contents",
          child_sections: child_sections,
        },
        change_history: change_history,
      },
      routes: [
        {
          path: manual.base_path,
          type: "exact",
        }
      ],
      redirects: [],
      update_type: manual.update_type,
    }
  end

private
  attr_reader :manual

  def public_updated_at
    manual.public_updated_at.to_datetime.rfc3339
  end

  def child_sections
    [] # TODO export Sections
  end

  def change_history
    [] # TODO export change_history
  end
end
