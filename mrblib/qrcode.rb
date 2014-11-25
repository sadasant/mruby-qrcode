class QRError < StandardError; end

class QR
  attr_accessor :msg, :version, :mode, :eclevel, :masktype;

  # As in qrcode/libqr/qr.h where QR_EM_AUTO and others are defined
  def get_mode(key)
    case key
    when "S", "s" then -1 # AUTO
    when "N", "n" then  0 # NUMERIC
    when "A", "a" then  1 # ALNUM - British number: 0-9 A-Z SP $% * + - /.:
    when "8"      then  2 # 8BIT
    when "K", "k" then  3 # KANJI
    end
  end

  # As in qrcode/libqr/qr.h where QR_ECL_L and others are defined
  def get_level(key)
    case key
    when "L", "l" then  0 # Level L
    when "M", "m" then  1 # Level M
    when "Q", "q" then  2 # Level Q
    when "H", "h" then  3 # Level H
    end
  end

  # As in qrcode/libqr/qr.h where QR_FMT_PNG and others are defined
  def get_fmt(key)
    case key
    when "PNG"  , "png"   then  0
    when "BMP"  , "bmp"   then  1
    when "TIFF" , "tiff"  then  2
    when "PBM"  , "pbm"   then  3
    when "SVG"  , "svg"   then  4
    when "JSON" , "json"  then  5
    when "DIGIT", "digit" then  6
    when "ASCII", "ascii" then  7
    end
  end

  def initialize(msg, version=-1, mode="S", eclevel="M", masktype=0)
    @msg      = msg
    @version  = version
    @mode     = mode
    @eclevel  = eclevel
    @masktype = masktype
  end

  def generate(format="bmp", mag=3)
    QR._generate(@msg, @version, get_mode(@mode), get_level(@eclevel), @masktype, get_fmt(format), mag)
  end

end
