class TagsController < ApplicationController
  def show
    tag = Tag.find_by(name: params[:name])
    @learnings = tag.learnings.includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = "tag / #{tag.name}"
    render 'shared/learnings'
  end
end
