Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72BB6B6C87
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Mar 2023 00:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjCLXbQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 12 Mar 2023 19:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCLXbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Mar 2023 19:31:15 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5FE23674
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 16:31:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so9914212pjg.4
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 16:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678663870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xGsRfyWirO1vSkNZurgVxrSIuOQUCszDrkoyMT09sQs=;
        b=NboYJvQ0YuDQbYw2M1vU9JVEzDJsjSLEbY9WsRGsLeDGylvi9+jWzHvjyQsXInv/vh
         5dUJGO59oE44kzMCqDvvyK9i0mAI49aWsGk/ZzRr4oHwPjQEyOFnMSvHgALiQGhLiXTr
         JMikS88mniyswWrjBAkLMdqzfLSR8DccSOsu/MwTwTCb7kPiUlrs4CTmAffKJiqXcxuq
         gwVJ9E1bcqrT8qMzrAWeleGhPrt7/Zdr9E4DiOXQgyCY6+E+CZMhIIJcw+DDvxKI9NQF
         2wxmm4cljnXAien+Q36htyf30E7LxnGeEvszsGg5zaVw4uLiKB4Xr5qJiFuqmHC1KEBY
         H9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678663870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGsRfyWirO1vSkNZurgVxrSIuOQUCszDrkoyMT09sQs=;
        b=SX32NSL3uTfR1wfK47/PoBmmQ2uogHE5USQ6AYQBtVzJ1fEMKOoSxW1zToliP6Ly94
         gzIIb4P1I76MINvqRNeQzD317IJaFa7pRV5EJl46TqXX4Z6wRjTILjC2Kd4/QDVBZwMo
         l291vxuxjWUQ3Svp4zq6CgYQ4F7eRFyUzRzyEiIM2qz6jA/n+WWZ7KpCqW8k2AMgo5BC
         BsINn0kHbgsXXXlTmjx3GzVXV/YLG/3mrQ1u5/rgTpNCCGJ+/9Kx+9XKZ+YeUlVtokpR
         FEpvfbEoxg5bEBzAlbeYB9o1vgub/parnctTrNuOpFahbmAa4UIQLTr9meDnz1H7yhnP
         pfhA==
X-Gm-Message-State: AO0yUKX1u05O+NcGv3CH1tgRJ+6QZ2P1sXmPM1GDlr2KTvAvwRIEiB+H
        ToG62IAv+atmnsEUHk6Py181XA==
X-Google-Smtp-Source: AK7set8Fgsjo4bRIW0pN3fgU3x2K1goOzHfUWcYXBk2t7zY/FyA9xynwVPuBAWLpp35yhUEYeP8MOw==
X-Received: by 2002:a17:903:120b:b0:19e:82aa:dc8a with SMTP id l11-20020a170903120b00b0019e82aadc8amr37238346plh.22.1678663870328;
        Sun, 12 Mar 2023 16:31:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id bb12-20020a170902bc8c00b001933b4b1a49sm3311784plb.183.2023.03.12.16.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:31:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pbV9e-0083Cw-KQ; Mon, 13 Mar 2023 10:31:06 +1100
Date:   Mon, 13 Mar 2023 10:31:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        keescook@chromium.org, yzaikin@google.com, j.granados@samsung.com,
        patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: simplify two-level sysctl registration for xfs_table
Message-ID: <20230312233106.GP360264@dread.disaster.area>
References: <20230310230219.3948819-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310230219.3948819-1-mcgrof@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 10, 2023 at 03:02:19PM -0800, Luis Chamberlain wrote:
> There is no need to declare two tables to just create directories,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> This is not clear to some so I've updated the docs for the sysctl
> registration here:
> 
> https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     
> 
>  fs/xfs/xfs_sysctl.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
