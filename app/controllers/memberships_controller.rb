class MembershipsController < ApplicationController

  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:accept]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create



    @membership = Membership.new(beer_club_id: params[:membership][:beer_club_id], user_id: current_user.id, confirmed: false)

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_path(params[:membership][:beer_club_id]), notice: "Welcome #{current_user.username}" }
        format.json { render :show, status: :created, location: @membership }

      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
        @beer_clubs = BeerClub.all
      end
    end
  end


  def accept
    membership = Membership.find_by id: params[:id]
    redirect_to root_path unless membership.beer_club.confirmed_members.include? current_user
    membership.confirmed = true
    membership.save

    redirect_to beer_club_path(membership.beer_club)
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    club_id = @membership.beer_club.id
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to beer_club_path(club_id), notice: 'You are no longer a member of this club' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_id, :beer_club_id)
    end
end
