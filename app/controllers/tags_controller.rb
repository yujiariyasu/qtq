class TagsController < ApplicationController
  def show
    tag = Tag.find(params[:id])
    @learnings = tag.learnings.includes(:user).order(id: :desc).page(params[:page]).per(30)
    @title = tag.name
    render 'shared/learnings'
  end
end
