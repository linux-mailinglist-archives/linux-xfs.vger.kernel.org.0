Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA564AFA
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 18:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfGJQwK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 12:52:10 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:37664 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfGJQwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:52:09 -0400
Received: by mail-wm1-f41.google.com with SMTP id f17so2990194wme.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aVbhy0mzzDNKu/ExfwYMlCJwB55YUWpJCYpzbeEQRd0=;
        b=iOxKxy4dswEhEYLQOw38H6/DMF9QKYqxxjC2bBJgmAwV/NiQ4S42Z2MSOclDMezinz
         MTYn+gS+MiqHeTAAmaH+zKakI3GeIhr1w0oHRe8Nx78xev1M+FJdVeI15+DSjUvtHCIw
         taBHm5Tk5mguW8SWJx5sw5vQDSspBemZ78WLX9BASyoNVyHDp8560KmNuiXHQdpvFrdb
         dP4861LJE6Q7P3gsbzVLFoEjEJDfgo3tTTYCdZ+fN9/f3vphIxYlvCIUseG+cyfoNFRZ
         4uwTS1u0EhGXLgnZVvEtxHTv1SwPUE1JE2CbpqtWaJjnbxyC/977PgPYj7UkKKPHINfk
         T7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aVbhy0mzzDNKu/ExfwYMlCJwB55YUWpJCYpzbeEQRd0=;
        b=IzahK4dyB57HasnjHol8oqGzC7UFtjgUTeY4zFtYTzKtpotlz0hCvcJkgyR48ZCz4L
         y1M3C1Ofo/a/MJMNKmwDdcjtOy6hVj78cuBzdGcc+9dPgjG/ez6YUpIyoF6g7A9nVj8x
         kSaP+Xwuz6t/fr0MWcoiYj4o4HN5dqjBAGa7EfHpOB+lxe229Mv6la9giQ+JAEwDgCd+
         UpHUgOiwU5zP+uxiSsruNa6ax1pAMy6wiXG5eL8AcNL+7HLp/vk1/co8+Xm5GFS+AuF9
         bB89xPiSkxRYP7S6v2fTmtiDB7kAIvPBp5L2JyIYoWrXAL0owLM1dTW0zMVJjAJE6SHX
         s6Cg==
X-Gm-Message-State: APjAAAWy/FTNK0jrht71kD/z+zBS9iRjcTU4T6Rn/mwD7MPwg6byWoAP
        NQkjZamXbTwGkgVbF2jAOMMS6/owRHytPgp+U9M=
X-Google-Smtp-Source: APXvYqzqu0gY98KJKz3IuG9UFqYtpuuLzfz18pLtekr/m98kveh2utwSIKHRj3F4Aq02H84TD0fLUB6OYrsNe3oPQM8=
X-Received: by 2002:a1c:7a15:: with SMTP id v21mr6215264wmc.176.1562777527706;
 Wed, 10 Jul 2019 09:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru>
In-Reply-To: <1015034894.20190710190746@a-j.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Jul 2019 10:51:56 -0600
Message-ID: <CAJCQCtQgA8aqF+S+6xk6d-vykaaQsJCHKH1=dn46AJnrjcugTg@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 10, 2019 at 10:08 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>
>
> Wednesday, July 10, 2019, 6:45:28 PM, you wrote:
>
> The '-x' option gives a lot of output.
> It's pasted here: https://pastebin.com/raw/yW3yDuSF

  9 Power_On_Hours          -O--CK   022   022   000    -    56941

56941=C3=B78760 =3D 6.5 years ?

Doubtful it's under warranty.


--=20
Chris Murphy
