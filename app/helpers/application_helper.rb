module ApplicationHelper

   # Return a title on a per-page basis.
  def title
    base_title = "raspas"
    if @title.nil?
      base_title
    else 
      if @micropost
        if @micropost.author
          "#{@title} { #{@micropost.author.name}"
        else
          "#{@title} { #{@micropost.user.name}"
        end
      elsif home
        "raspas { #{@title}"
      else
        "#{@title} { #{base_title}"
      end     
    end
  end

  def page_description(description)
    base_description = "Passe seu conhecimento adiante. Crie, colecione e compartilhe pensamentos com o raspas."
    description.empty? ? base_description : description
  end

  def logo
  	image_tag("logo.png", :alt => "raspas", :class => "logo")
	end

  def active?(controller, action)
    "active" if controller?(controller) && action?(action)
  end

  def text_active?(controller, action)
    "text_active" if controller?(controller) && action?(action)
  end

  def page_active?(controller, action)
    "page_active" if controller?(controller) && action?(action)
  end

  private

    def controller?(*controller)
      controller.include?(params[:controller])
    end

    def action?(*action)
      action.include?(params[:action])
    end
end 