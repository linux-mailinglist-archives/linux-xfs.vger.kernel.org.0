Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDE32E39A
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Mar 2021 09:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCEIZd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Mar 2021 03:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhCEIZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 03:25:32 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767EBC061574;
        Fri,  5 Mar 2021 00:25:32 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id i14so1405341pjz.4;
        Fri, 05 Mar 2021 00:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Yuate5vM9GbIybS3sYgHWA8kHMzENphSwRcJRwJI2E8=;
        b=Avv0yd23iiJISXeb5jA4h4q0UH/8KG4cc9H00cUyc6AS4oOfCvJossWCZYQyGJkiZ2
         kjhwqTB4e763JzRWqD57FU9s9brVOF/mwXrz7GedCNGFu60K8fe5SNP+lhMB1rE/+VwD
         5UZph05s/XMmvgQnwrwchgaewkEvPw2r9y2m4eJyeR6IuWM2oSfeesqYKu/wnvarOuIn
         SxW4CPbeiF9R8wMfD+tQutEtwA+QvT92wu4Nf5lvEhEFBG7q4k6w8djkJKpKdK7vpt0e
         qrDdA/KLNW1Xka5CC+p98/qkN8QjRuQUtgCA73HyNieCDwG2Xb7eIdHhHLzygYsnM0In
         1DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Yuate5vM9GbIybS3sYgHWA8kHMzENphSwRcJRwJI2E8=;
        b=Z9keEkMOnNixl5/NnkIs+N9zdVavRJRC8zf+T2P3KK4VsXdQ0dO7xO2XzT6exS7KWj
         jwsYxmm2jBPcmEUbnYqyZisaXWGDGIYzVDGPxwsP3JWBRWOj/03hI7a4kAR7a0Zcfinb
         wrg0e/C+CBfDl3Dgdkv2/vzG6AkoFvaGSEbT2JaOmiVBzq3Qi5XkyP79lrdzQ/pHkocw
         //FJ0UCRHYLHFdnQ/st6llDk5l7SRQeepBwkQWJ17NfXs9zWqeU+6oSPdYCa4MEMZTtz
         4i4fAXdvQw2uDOD2EtD3bvyyRrowHetYApdWfhFAkDyM05xWEFFfV3p0A2BH0Z1f8FC0
         gpiA==
X-Gm-Message-State: AOAM533vDh0khBRum1Rz1JfM+UWgi0MXN5RW8EohkFwiCgdYr4gGXIpH
        Vg7w7oGchcZZNqVn0k8UVUE=
X-Google-Smtp-Source: ABdhPJza9qUR1/diyp5ho1E4PK1IgdloXkkWr/HIIYSS1TdgrepvRNwh0SUCCyfjlDAW65thB9NViQ==
X-Received: by 2002:a17:90a:a10a:: with SMTP id s10mr9203675pjp.36.1614932732125;
        Fri, 05 Mar 2021 00:25:32 -0800 (PST)
Received: from garuda ([122.171.172.255])
        by smtp.gmail.com with ESMTPSA id x11sm12786961pjh.0.2021.03.05.00.25.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 00:25:31 -0800 (PST)
References: <161472735404.3478298.8179031068431918520.stgit@magnolia> <161472737079.3478298.2584850499235911991.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/4] common/rc: fix detection of device-mapper/persistent memory incompatibility
In-reply-to: <161472737079.3478298.2584850499235911991.stgit@magnolia>
Date:   Fri, 05 Mar 2021 13:55:28 +0530
Message-ID: <87lfb2t3bb.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 04:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In commit fc7b3903, we tried to make _require_dm_target smart enough to
> _notrun tests that require a device mapper target that isn't compatible
> with "DAX".  However, as of this writing, the incompatibility stems from
> device mapper's unwillingness to switch access modes when running atop
> DAX (persistent memory) devices, and has nothing to do with the
> filesystem mount options.
>
> Since filesystems supporting DAX don't universally require "dax" in the
> mount options to enable that functionality, switch the test to query
> sysfs to see if the scratch device supports DAX.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Fixes: fc7b3903 ("dax/dm: disable testing on devices that don't support dax")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
>
> diff --git a/common/rc b/common/rc
> index 7254130f..10e5f40b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1889,7 +1889,8 @@ _require_dm_target()
>  	_require_sane_bdev_flush $SCRATCH_DEV
>  	_require_command "$DMSETUP_PROG" dmsetup
>  
> -	_normalize_mount_options | egrep -q "dax(=always| |$)"
> +	_normalize_mount_options | egrep -q "dax(=always| |$)" || \
> +			test -e "/sys/block/$(_short_dev $SCRATCH_DEV)/dax"
>  	if [ $? -eq 0 ]; then
>  		case $target in
>  		stripe|linear|log-writes)


-- 
chandan
