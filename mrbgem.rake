MRuby::Gem::Specification.new('mruby-qrcode') do |spec|
  spec.license = 'GPL'
  spec.authors = 'sadasant@gmail.com'

  spec.cc.include_paths << "#{build.root}/src"

  qrcode_dirname = 'qrcode'
  qrcode_src = "#{spec.dir}/#{qrcode_dirname}/libqr"
  spec.cc.include_paths << "#{qrcode_src}"


  if ( /mswin|mingw|win32/ =~ RUBY_PLATFORM ) then
    spec.cc.defines << "QR_DLL_BUILD"
  end

  spec.objs += %W(
    #{qrcode_src}/qr.c
    #{qrcode_src}/qrcnv.c
    #{qrcode_src}/qrcnv_bmp.c
  ).map { |f| f.relative_path_from(dir).pathmap("#{build_dir}/%X.o") }

end
