MRuby::Gem::Specification.new('mruby-qrcode') do |spec|
  spec.license = 'MIT'
  spec.authors = ['sadasant', 'scalone']
  spec.summary = 'Ruby interface to QR Code C Library by Ryusuke SEKIYAMA'
  spec.version = '1.0.0'

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
