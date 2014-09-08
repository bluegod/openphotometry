require 'fileutils'
require 'qless'
require 'date'
require 'will_paginate/array'

class PagesController < ApplicationController


  def home
    @client = Qless::Client.new
    queue = @client.queues['testing']
    job_types = %w[waiting running scheduled stalled depends recurring ].to_set
    #@jobs = queue.jobs.send('running').map { |jid| @client.jobs[jid] }
    @jobs = @client.jobs.send('complete').map { |jid| @client.jobs[jid] }

    @client.jobs.failed.keys.map do |t|
      @client.jobs.failed(t).tap { |f| @jobs.concat f["jobs"]}
    end
    @jobs.concat queue.peek(20)

    @jobs = @jobs.sort_by { |j| - j.raw_queue_history[0]['when'] }
    @jobs = @jobs.paginate(:page => params['page'], :per_page => 15)
  end

  def about

  end

  def help

  end

  def js9prefs
    render :file   => File.join(Rails.root, 'public', 'js9Prefs.json ')
  end

  def photo
   puts params

   begin

   raise ArgumentError, 'Ingress/Egress not specified.' if params['datetimepicker1'].blank? || params['datetimepicker2'].blank?
   raise ArgumentError, 'Target name not specified.' if params['targetName'].blank?
   raise ArgumentError, 'Target star / comparison stars not selected.' if params['stars_location'].blank?


   apertureRadius = 4.5
   if !params['apertureRadius'].blank?
     apertureRadius = params['apertureRadius'].to_f
   end

   targetName = params['targetName']

   ingressDate = DateTime.parse(params['datetimepicker1'])
   ingress = ingressDate.strftime('%F ; %T')

   egressDate = DateTime.parse(params['datetimepicker2'])
   egress = egressDate.strftime('%F ; %T')



   uploader = ImageUploader.new
     uploader.ds9
     FileUtils.mkdir_p 'public/' + uploader.store_dir
     f = File.open('public/' + uploader.store_dir + 'ds9.reg', 'w') { |f| f.write(params[:stars_location]) }
     params[:darks].each do |d|
       uploader.darks
       uploader.store!(d)
     end

     params[:flat].each do |d|
       uploader.flat
       uploader.store!(d)
     end

     params[:data].each do |d|
       uploader.images
       uploader.store!(d)
     end

     if params.size < 8
       raise ArgumentError, 'Error: Not all the parameters have been filled.'
     end

     # This references a new or existing queue 'testing'
     @client = Qless::Client.new
     queue = @client.queues['testing']

     #Get the base path from the last file saved
     base_dir = File.expand_path('../../', uploader.file.path)

     # Let's add a job, with some data. Returns Job ID
     queue.put('openPhotoJob.openPhotoJob',
               :name => params['inputSmall'],
               :file_count=> params[:darks].size + params[:flat].size + params[:data].size,
               :visibility => 'public',
               :token => uploader.token,
               :path => base_dir,
               :targetName => targetName,
               :ingress => ingress,
               :egress => egress,
               :apertureRadius => apertureRadius

     )
     flash[:notice] = 'Successfully submitted job '
   rescue => e
     flash[:error] = e.message
     puts e.backtrace
   ensure
     #f.close
   end
   redirect_to '/'
  end

end
