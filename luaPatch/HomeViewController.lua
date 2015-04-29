

waxClass{"HomeViewController", UIViewController}


function homeItemViewAction(self, itemView)
    local num = itemView:item():tag()
    puts(type(num)..num)

    if (num == 1100) then
         self:adsJump()
    elseif (num == 1200) then
         self:mainPageController():goModule(MainTypeHotel)
    else
    end

end