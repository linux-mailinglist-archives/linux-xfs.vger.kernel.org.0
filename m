Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C205E70E80B
	for <lists+linux-xfs@lfdr.de>; Tue, 23 May 2023 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbjEWVxK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 May 2023 17:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbjEWVxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 17:53:07 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3661BF
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 14:53:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a516fb6523so1572785ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 14:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684878782; x=1687470782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Im/fXNrdtdh448/x5vPWa+KOEv9ipXtehLMOS6lDlss=;
        b=uZAsBWtqR4l/fFgleDDi1e4cBPSXQn6MLIkXNqldkh28u96vZVG4S7tzPCzjl8kkk4
         3sJyz5LXU3JCKwd5EXZLOTHGXqfIl4DvHwuILOtZ52f/l7yIcByUZyQBjXo9+O33Jraa
         ETqCVuFWhNVNkGO1s7/KXoFztBAMw8K7NZnNxxJuLMx7pKWNRQ4KLBfcCiOxwkbZssU0
         axah+nx/7Fv1Lcm+U+7PxW5IR5/Xl4jTypJgk72uOnPsQeZ1DnB6hGWZ6QbVgHYJ3N9C
         6vvW8ymvWcbnIGvR1peDLbdyaGLWeIwCg52h/tmIB/hGoq5rqshphSWZQMsjIXBvFck2
         v+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684878782; x=1687470782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Im/fXNrdtdh448/x5vPWa+KOEv9ipXtehLMOS6lDlss=;
        b=juEXFafxGx+5zchogH3bsWSsFxwBqT4urnif3HiBUDGLnr/FfYbLvjIYvC26DbAAOq
         qBhYPaulptFtq+5HlidQH9aRm5BqxMW4A94vj057tG36uq/1EzgrFhAFGoWTUNViz8D/
         dIlSNT11bLpnryHGy4+lZ/DjXeOFYjwZaTAQL+HHR6zKlz8KhvcYGoH6b/vzTiGwWHGa
         AJB1sLVMcs+Htuh/JIER6UG1Ody+/3nGS46+YADji6aX1D6co/Mi3gLEB3JQmC+9ZjGm
         sy1Vzsdj5UES4aQDRe7FPQmEWvEbRde5SWhBPfmK0HLeXvIbjqsXH6ncHc+GMyDV3vSh
         w04g==
X-Gm-Message-State: AC+VfDz6jaW93QWjWhuNTculIwalBsHoIXO/JAEsE3hIEblMMFm63ABG
        OZkPuR4yWiWBh/+dk4f1VkIKcA==
X-Google-Smtp-Source: ACHHUZ7fyzANrlD5gDYJjywUoAY1KKzWqRPDkZMuU5ssh+xI2BalbzVXVwX1qAbOA/A/CxsEdUYjEg==
X-Received: by 2002:a17:902:c40d:b0:1af:ddef:f605 with SMTP id k13-20020a170902c40d00b001afddeff605mr486823plk.65.1684878782390;
        Tue, 23 May 2023 14:53:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902759000b001a6a6169d45sm7279540pll.168.2023.05.23.14.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 14:53:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1ZwB-0035VU-0I;
        Wed, 24 May 2023 07:52:59 +1000
Date:   Wed, 24 May 2023 07:52:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        heng.su@intel.com, dchinner@redhat.com, lkp@intel.com,
        Linux Regressions <regressions@lists.linux.dev>
Subject: Re: [Syzkaller & bisect] There is BUG: unable to handle kernel NULL
 pointer dereference in xfs_extent_free_diff_items in v6.4-rc3
Message-ID: <ZG01u5KGsCBnWVGu@dread.disaster.area>
References: <ZGrOYDZf+k0i4jyM@xpf.sh.intel.com>
 <ZGsOH5D5vLTLWzoB@debian.me>
 <20230522160525.GB11620@frogsfrogsfrogs>
 <20230523000029.GB3187780@google.com>
 <ZGxry4yMn+DKCWcJ@dread.disaster.area>
 <ZGyD8CNObpTbEeGQ@xpf.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGyD8CNObpTbEeGQ@xpf.sh.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 05:14:24PM +0800, Pengfei Xu wrote:
>   I did not do well in two points, which led to the problem of this useless
>   bisect info:
>   1. Should double check "V4 Filesystem" related issue carefully, and should
>      give reason of problem.
>   2. Double check the bisect bad and good dmesg info, this time actually
>      "good(actually not good)" dmesg also contains "BUG" related
>      dmesg, but it doesn't contain the keyword "xfs_extent_free_diff_items"
>      dmesg info, and give the wrong bisect info.
>      Sorry for inconvenience...

I think you misunderstand.

The bisect you did was correct - the commit it
identified was certainly does expose the underlying issue.

The reason the bisect, while correct, is actually useless is that it
the underlying issue that the commit tripped over is not caused by
the change in the commit. The underlying issue has been there for a
long while - probably a decade - and it's that old, underlying issue
that has caused the new code to fail.

IOWs, the problem is not the new code (i.e. it is not a regression
in the new code identified by the bisect), the problem is in other
code that has been silently propagating undetected corruption for
years. Hence the bisect is not actually useful in diagnosing the
root cause of the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
