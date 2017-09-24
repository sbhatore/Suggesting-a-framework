class MainControllerController < ApplicationController
	@@ans = "Not found"
	@@var1 = ""
	@@var2 = ""
	@@var3 = ""
	@@var4 = ""
	@@var5 = ""
	def admin
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
	end
	def saved_framework
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
		@@var1 = ans
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
		ans3 = []
		map = {}
		if !hosting.nil?
			if !(hosting.include? "Other") && !(hosting.include? "Any")
				Framework.all.each do |row|
					if !ans2.nil?
						if ans2.include? row["framework"]
							if (parse(row["hosting"])&hosting).length != 0
								ans3.push(row["framework"])
								count[row["framework"]] = count[row["framework"]] +
								 (parse(row["hosting"])&hosting).length
								map[row["framework"]] = (parse(row["hosting"])&hosting).length
							end
						end
					end
				end
			else
				ans3 = ans2
			end
		end
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
						elsif time = "30-60"
							if row["time"] < 60
								ans4.push(row["framework"])
							else
								count.delete(row["framework"])
							end
						else
							ans4.push(row["framework"])
						end
					end
				end
			end
		end
		ans5 = []
		map2 = {}
		map1 = {}
		if !databases.nil?
			if !(databases.include? "Any")
				Framework.all.each do |row|
					if ans4.include? row["framework"]
						if ((parse(row["database"])&databases).length) != 0
							ans5.push(row["framework"])
							count[row["framework"]] = count[row["framework"]] +
							 (parse(row["database"])&databases).length
							map1[row["framework"]] = map[row["framework"]]
							map2[row["framework"]] = (parse(row["database"])&databases).length
						end 
					end
				end
			else
				ans5 = ans4
			end
		end
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
		count= count.sort_by {|_key, value| value}.to_h
		@@var5 = count
		if !count.nil?
			ans = count.to_a.last[0]
		else
			ans = "No matching Framework found as per your requirements"
		end
		size1 = 0
		Framework.all.each do |row|
			if !count.nil?
				if row["framework"] == count.to_a.last[0]
					if !row["community_size"].nil?
						size1 = row["community_size"]
						break
					end
				end
			end
		end
		size2 = 0
		count.each do |key, value|
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
			if !ans.nil?
				@@ans = ans
			else
				@@ans = "No framework found satisfying your requirements"
			end
		end
		render :text => @@ans.inspect
	end

	def parse(str)
		return str.split(',')
	end
end
