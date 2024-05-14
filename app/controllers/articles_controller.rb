class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :edit]

  def index
    @articles = Article.all 
  end

  def data
    # Получаем данные из базы данных, например, из модели Chart
    #date = params[:date]
    # Выполняем фильтрацию по дате, если она была передана
    #data = Fz44.where(Publication_Date: date)
    data = [
      { "date": "2023-01-01", "value": 100 },
      { "date": "2023-01-02", "value": 150 },
      { "date": "2023-01-03", "value": 200 },
      { "date": "2023-01-04", "value": 180 },
      { "date": "2023-01-05", "value": 220 }
    ]
    #data = data.where(date: params[:date])
    if params[:date].present?
      filtered_data = data.select { |item| item[:date] == params[:date] } 
    else
      filtered_data = data
    end
    
    render json: filtered_data
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article.update(article_params)
    redirect_to @article
  end

  def edit
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
    def set_article
      @article = Article.find(params[:id])
    end
end
