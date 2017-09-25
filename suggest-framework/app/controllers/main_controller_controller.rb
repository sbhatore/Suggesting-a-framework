require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'
require 'bcrypt'
class MainControllerController < ApplicationController
	@@ans = "Not found"
	@@var1 = ""
	@@var2 = ""
	@@var3 = ""
	@@var4 = ""
	@@var5 = ""
	@@var6 = ""
	def admin
	end
	def saved_framework
		f = Framework.new
		if(!params.nil?)
			f.framework = params[:framework]
			f.language = params[:language]
			f.rps = params[:rps]
			f.community_size = params[:community_size]
			f.license = params[:license]
			f.time = params[:time]
			f.hosting = params[:hosting]
			f.databases = params[:databases]
			f.patterns = params[:patterns]
			f.save
		end
		render :text => Framework.inspect
	end
	def view
		if(!params.nil?)
			languages = params[:language]
			licenses = params[:license]
			hosting = params[:hosting]
			time = params[:time]
			databases = params[:database]
			patterns = params[:patterns]
		else
			languages = []
			licenses = []
			hosting = []
			time = []
			databases = []
			patterns = []
		end
		@@var3 = params[:language]
		ans = []
		count = {}
		Framework.all.each do |row|
			ans.push(row["framework"])
			count[row["framework"]] = 0
		end
		@@var1 = languages
		ans1 = []
		if !languages.nil?
			if !(languages.include? "Other")
				Framework.all.each do |row|			
					if languages.include? row["language"]
						ans1.push(row["framework"])
					else
						count.delete(row["framework"])
					end
				end
			else
				ans1 = ans
			end
		end
		@@var2 = ans1
		q2 = ans1
		ans2 = []
		if !licenses.nil?
			if !(licenses.include? "Other")
				Framework.all.each do |row|
					if !ans1.nil?
						if ans1.include? row["framework"]				
							if licenses.include? row["license"]
								ans2.push(row["framework"])
							end
						end
					end
				end
			else
				ans2 = ans1
			end
		end
		@@var4 = ans2
		q1 = ans2
		ans3 = []
		map = {}
		arr = []
		arr.push(hosting)
		if !hosting.nil?
			if !(hosting.include? "Other") && !(hosting.include? "Any")
				Framework.all.each do |row|
					if !ans2.nil?
						if ans2.include? row["framework"]
							if (parse(row["hosting"])&arr).length != 0
								ans3.push(row["framework"])
								count[row["framework"]] = count[row["framework"]] +
								 (parse(row["hosting"])&arr).length
								map[row["framework"]] = (parse(row["hosting"])&arr).length
							end
						end
					end
				end
			else
				ans3 = ans2
			end
		end
		q3 = ans3
		ans4 = []
		Framework.all.each do |row|
			if !ans3.nil?
				if ans3.include? row["framework"]
					if !row["time"].nil?
						if time == "<30"
							if row["time"] < 30
								ans4.push(row["framework"]);
							else
								count.delete(row["framework"])
							end
						elsif time == "30-60"
							if row["time"] < 60
								ans4.push(row["framework"])
							else
								count.delete(row["framework"])
							end
						else
							@@var1 = row["framework"]
							ans4.push(row["framework"])
						end
					end
				end
			end
		end
		q4 = ans4
		ans5 = []
		map2 = {}
		map1 = {}
		if !databases.nil?
			if !(databases.include? "Any")
				Framework.all.each do |row|
					if ans4.include? row["framework"]
						@@var6 = parse(row["database"])
						if ((parse(row["databases"])&databases).length) != 0
							ans5.push(row["framework"])
							count[row["framework"]] = count[row["framework"]] +
							 (parse(row["databases"])&databases).length
							map1[row["framework"]] = map[row["framework"]]
							map2[row["framework"]] = (parse(row["databases																																												"])&databases).length
						end 
					end
				end
			else
				ans5 = ans4
			end
		end
		q5 = ans5
		ans6 = []
		map3 = {}
		map12 = {}
		map22 = {}
		if !patterns.nil?
			if !(patterns.include? "Other")
				Framework.all.each do |row|
					if ans5.include? row["framework"]
						if ((parse(row["patterns"])&patterns).length) != 0
							ans6.push(row["framework"])
							map12[row["framework"]] = map1[row["framework"]]
							map22[row["framework"]] = map2[row["framework"]]
							count[row["framework"]] = count[row["framework"]] + 
							(parse(row["patterns"])&patterns).length
							map3[row["framework"]] = (parse(row["patterns"])&patterns).length
						end 
					end
				end
			else
				ans6 = ans5
			end
		end
		q6 = ans6
		count= count.sort_by {|_key, value| value}.to_h
		@@var5 = count
		if !count.nil?
			if !count.to_a.empty?
				ans = count.to_a.last[0]
			else
				ans = "No matching Framework found as per your requirements"
			end

		else
			ans = "No matching Framework found as per your requirements"
		end
		var2 = ans
		size1 = 0
		var5 = 0
		Framework.all.each do |row|
			if !count.nil?
				if count.to_a.any?
					if row["framework"] == count.to_a.last[0]
						if !row["community_size"].nil?
							var5 = row["community_size"]
							size1 = row["community_size"]
							break
						end
					end
				end
			end
		end
		@@var3 = size1
		size2 = 0
		count.each do |key, value|
			if count.to_a.any?
				if value == count.to_a.last[1]
					Framework.all.each do |row|
						if row["framework"] == key
							if !row["community_size"].nil?
								size2 = row["community_size"]
								break
							end
						end
					end
					if size2 > size1
						size1 = size2
						ans = key
					end
				end
			end
		end
		@@var4 = size2
		if !ans.nil?
			@ans = ans
		else
			@ans = "No framework found satisfying your requirements"
		end
	end

	def update
	end
	def edit
		page = HTTParty.get('https://webhostingbuddy.com/list-of-web-hosting-companies/')
		parse_page = Nokogiri::HTML(page)
		arr = []
		a = parse_page.css('strong')
		a.ll.each do |b|
		end
		Pry.start(binding)
		render :text => a.inspect
	end

	def parse(str)
		if !str.nil?
			return str.split(',')
		end
		return []
	end
	def login
	end
	def authorize
		if params[:password] == "admin"
			redirect_to action: "admin"
		else
			redirect_to root_path
		end
	end
end