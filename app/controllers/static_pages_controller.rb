class StaticPagesController < ApplicationController
  allow_unauthenticated_access

  def ueber_uns; end
  def mitmachen; end
  def musikschule; end
  def chronik; end
  def impressum; end
  def datenschutz; end
end
