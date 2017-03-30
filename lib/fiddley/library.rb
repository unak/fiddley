require "fiddle/import"

module Fiddley
  module Library
    include Fiddle::Importer
    alias ffi_lib dlload

    def extended(mod)
      @convention = nil
    end

    def attach_function(rname, cname, params, ret = nil, blocking: false)
      if ret.nil?
        ret = params
        params = cname
        cname = rname
      end
      extern "#{Fiddley.type2str(ret)} #{cname}(#{params.map{|e| Fiddley.type2str(e)}.join(', ')})", @convention
      if cname != rname
        instance_eval <<-end
          alias #{rname.inspect} #{cname.inspect}
        end
      end
    end

    def ffi_convention(conv)
      @convention = conv
    end

    case RUBY_PLATFORM
    when /cygwin/
      libc_so = "cygwin1.dll"
      libm_so = "cygwin1.dll"
    when /linux/
      libdir = '/lib'
      case [0].pack('L!').size
      when 4
        # 32-bit ruby
        libdir = '/lib32' if File.directory? '/lib32'
      when 8
        # 64-bit ruby
        libdir = '/lib64' if File.directory? '/lib64'
      end
      libc_so = File.join(libdir, "libc.so.6")
      libm_so = File.join(libdir, "libm.so.6")
    when /mingw/, /mswin/
      require "rbconfig"
      crtname = RbConfig::CONFIG["RUBY_SO_NAME"][/msvc\w+/] || 'ucrtbase'
      libc_so = libm_so = "#{crtname}.dll"
    when /darwin/
      libc_so = "/usr/lib/libc.dylib"
      libm_so = "/usr/lib/libm.dylib"
    when /kfreebsd/
      libc_so = "/lib/libc.so.0.1"
      libm_so = "/lib/libm.so.1"
    when /gnu/	#GNU/Hurd
      libc_so = "/lib/libc.so.0.3"
      libm_so = "/lib/libm.so.6"
    when /mirbsd/
      libc_so = "/usr/lib/libc.so.41.10"
      libm_so = "/usr/lib/libm.so.7.0"
    when /freebsd/
      libc_so = "/lib/libc.so.7"
      libm_so = "/lib/libm.so.5"
    when /bsd|dragonfly/
      libc_so = "/usr/lib/libc.so"
      libm_so = "/usr/lib/libm.so"
    when /solaris/
      libdir = '/lib'
      case [0].pack('L!').size
      when 4
        # 32-bit ruby
        libdir = '/lib' if File.directory? '/lib'
      when 8
        # 64-bit ruby
        libdir = '/lib/64' if File.directory? '/lib/64'
      end
      libc_so = File.join(libdir, "libc.so")
      libm_so = File.join(libdir, "libm.so")
    end

    libc_so = nil if !libc_so || (libc_so[0] == ?/ && !File.file?(libc_so))
    libm_so = nil if !libm_so || (libm_so[0] == ?/ && !File.file?(libm_so))

    if !libc_so || !libm_so
      ruby = EnvUtil.rubybin
      ldd = `ldd #{ruby}`
      #puts ldd
      libc_so = $& if !libc_so && %r{/\S*/libc\.so\S*} =~ ldd
      libm_so = $& if !libm_so && %r{/\S*/libm\.so\S*} =~ ldd
      #p [libc_so, libm_so]
    end

    LIBC = libc_so
    LIBM = libm_so
  end
end
