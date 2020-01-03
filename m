Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0379412F6C9
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Jan 2020 11:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgACKiS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Jan 2020 05:38:18 -0500
Received: from sonic309-20.consmr.mail.ne1.yahoo.com ([66.163.184.146]:35260
        "EHLO sonic309-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727220AbgACKiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jan 2020 05:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578047897; bh=BwDPrsA2+wE7onqC1JBBbTtzaCQs5syyrmDpzadvHSI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=MmHTJJrC29MaptlkFNWzfL+Z78+RIB+J7Ksd/hLtZ8Wxt4W+c4unEZ9gs+eetjAuLf8qLwpeK2Be9sp8ewyQgmbYHNNs+3vfpyfbAp105hmEQ3CK4rTvu+Au5yrqjzq6UHh10FDhLCV2IAigUaCKgBZlxOGScXaLwsd88W8X/bwjapg5wKz/epMq23k8tYUD9CNRO8GR4iT2hLpLrlZ2hkyCmwvvt59dlODGyJDcp1LsiX4gW3z9VdkZN86pcqlxhumMtWKMktT2Nk5H0etm5uGP8SGvGxs0AcVpuB9WZi1G5OSpUf/wBkW9YmR8RGZnKwbcmg2V4MHs3vgBkTvHKQ==
X-YMail-OSG: zegebhoVM1nHXoFrF_n3.eoBKLJmwSuvgr9uOdjWxxuyGWU8FpzEUAFZgah8zoF
 ERbkvljwb16.FCJJkg73nq_TpldpUmcJCvdAJSl9.V0YhDCpTMsKr3fZ4AuVKh5NuKeQ3NIo37Go
 qxOndK5XPUD_VitG9O6RAUMSS_iiK42pVEbx0bMnVP9Z7uXY4PeHVosZi.iQA5.SszU3AMqgdoII
 T8HPlup6byklstSOUhjoMRIATvfEI2BAV4Dc0MWjOrVsLA0C_M905uQZe38i44ZR.8HiQjIOj1lr
 q5wBiWmblZEpgcwVttEDa4h7phyfFxPLYCeVxBjwsxUnYsL16MTDfuYbz5tCuKBGsdeKq1vVXUjb
 2xqRYH4E5GfD8qsfoAATTB0oRNVOBkOg43LFTqHHojc3CCRC2D8tz1llWfRTX_X9KhXhWSQR2E1J
 NhH7l13u.fZHJEfaZZjIDSP_TTW6N9Fh2blEZp4KLuGWIUaj_Dq0DVhqpy22iAq9I0IS2NWjG4HQ
 mHXeq40StHJ16dbTUDKreLByoW_gLeRmsVO2agN3Q6gc0SHtdb4sKm_g8MrdAi1VR_MBT5CiNVKI
 BLnuMp2JsIu1wexdh3QT8symyNzRSb9Yvh0sWB_EmiP7yEZ6_ztkkziWYo0w0cdEjrKZwpn72FTB
 aPV1DpRLioTeD2kGKwXkYjpxd6bhF.jcy48ZuGPHbjlo1bukjd0ZgBw7rHLdbhUIkydFMEVuSy.0
 mtz1GVovUiYnihUK7QAwF8Uat5tRrt25Poc4t5ieTbi2mKlqyPlTRhAwS1qu8MK_TEHJdgv8LlSs
 vUCytUgZjMdH_yGTuRDnZVuJ1_u44kUEgvC47CZF.UEkkPwx3CsgK4nDTF3xU6L3BhMCB5f_U36T
 qcoA7MCG0hmCxKqcBY2Lvg1da0uEig0rFqg2nF0LGMsu2TYUuAVOOkx5NTRcUduW9npSCSXyWU.n
 8jn3XREmJaqCJtEZtQ3RYj0FqWmnfHEElKUmdK_6oGs21ZN7wFwekL2q.Dq5MaUn6lJ4gY1H985W
 EboMxvCH2kz9X4yjNXHIqIOZVdF1U.wRelx.nWOJOSKiSigoS2QjR2HhUUGT7CATUN.5go6fMTew
 O2633d10hkyC7xtXsSeh5bk2WGzxXojfyOgU2A8eMyjT2pBU1X6s7UCoKXxR2_ZXRnJM7V4kEpne
 A0x2vm9j_dF_8zoFZvyqGdGH4_U_bg26Olu2EAq7d.qaWo.ZZ_Td13O_Z0HsynnXpN0IKRfvo8Mc
 wDGEKZTp85r4EeFtLVAq0gjWirYTszL6oXp2twfVOuYq7h4NxMS29wPoGGIaRH9cUiGz8KnoG7c4
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Fri, 3 Jan 2020 10:38:17 +0000
Date:   Fri, 3 Jan 2020 10:38:16 +0000 (UTC)
From:   Lisa Williams <wlisa2633@gmail.com>
Reply-To: lisa.wilams@yahoo.com
Message-ID: <1632349926.6233681.1578047896191@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1632349926.6233681.1578047896191.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:71.0) Gecko/20100101 Firefox/71.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa.
