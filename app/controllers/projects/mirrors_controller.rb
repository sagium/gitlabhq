class Projects::MirrorsController < Projects::ApplicationController
  # Authorize
  before_action :authorize_admin_project!, except: [:update_now]
  before_action :authorize_push_code!, only: [:update_now]
  before_action :remote_mirror, only: [:update]

  layout "project_settings"

  def show
    redirect_to namespace_project_settings_repository_path(@project.namespace, @project)
  end

  def update
    if @project.update_attributes(mirror_params)
      if @project.mirror?
        @project.update_mirror

        flash[:notice] = "Mirroring settings were successfully updated. The project is being updated."
      elsif @project.mirror_changed?
        flash[:notice] = "Mirroring was successfully disabled."
      else
        flash[:notice] = "Mirroring settings were successfully updated."
      end

      redirect_to namespace_project_mirror_path(@project.namespace, @project)
    else
      render :show
    end
  end

  def update_now
    if params[:sync_remote]
      @project.update_remote_mirrors
      flash[:notice] = "The remote repository is being updated..."
    else
      @project.update_mirror
      flash[:notice] = "The repository is being updated..."
    end

    redirect_back_or_default(default: namespace_project_path(@project.namespace, @project))
  end

  private

  def remote_mirror
    @remote_mirror = @project.remote_mirrors.first_or_initialize
  end

  def mirror_params
    params.require(:project).permit(:mirror, :import_url, :mirror_user_id,
                                    :mirror_trigger_builds, :sync_time,
                                    remote_mirrors_attributes: [:url, :id, :enabled, :sync_time])
  end
end
