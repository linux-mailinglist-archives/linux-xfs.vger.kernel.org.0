Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C708649C8D
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 11:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfFRJCs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 05:02:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36456 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbfFRJCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 05:02:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so7281435pfl.3;
        Tue, 18 Jun 2019 02:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OT416XH2f73kpKnz0+NFLtbyacLLwTMhw6RAtOeGU/s=;
        b=ne1QLrcQ/ulFdEVjbUYPinY6hEtPhh36JXIrkIJmcUa0F9Dfor3s82EuFLAP7rMt0K
         TZ0N+PM4sgEn0R5NGC71nWmOQetn7+MrBjlDpQjs3GJO/G/v7nCDPuAHhKj9Pzad7NRR
         pXVzYYZqyObj74F8+6fSH+NjMQdB0ATSboU38j9Vi7wEDTq2pwOkDLC43wYG7i3Ftcs3
         /it1o6e6wbvVeK4mZGMxTM73WH3yaby/QWSE747GAeLiBHm7YPC+gPgV0tCF5rlXn1F6
         wxoVWAz1+KHU0X6qs6gYWnvctlFZtGkbnc4J+l4/La+ECiPY2HojNCNHwJDvIwgWJbEg
         sXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OT416XH2f73kpKnz0+NFLtbyacLLwTMhw6RAtOeGU/s=;
        b=dqm9GnK37wu7P3RQijQjPKGowjLKmscOwS8oQ2mHJYcHMVz3w6iBkm/beg6rzeDdM2
         U7aUPqeMDCpSsU4BxlmXWjxubjLi9d/aKmOwzY6b/C3bPnA8At4p4U4UO4URdLA5RL0z
         A1q+l0N7YcEGIJyFDTORDQt9d5Q0mQWqBWxBsyXiwR/6wmaF6ZEUB+cjKUg5zZnSsKwW
         68rGDWOoI4vA3Ls9428+7uaDDjnlE4/CTevCVlhPyhi7sA31lpS/zaUC9PZKkoSSHilv
         cTHYIKg59tyoDEN0FmbcMgldRqBV/aX3ojYf0GQM1co0tCyXgYOk3ZsGgVWW7gF9dlBr
         MT5A==
X-Gm-Message-State: APjAAAUm/Cn9Z31BosIFttxuJw2+o/IyzAh28PZeVDi+qQ5fEBPY3oJ+
        TqYRm4N73lS9gfP+blQCYUdKRVYDh1Y=
X-Google-Smtp-Source: APXvYqwGn5kOIDNQgFDz/Zbr5CsJDHz7LzaQ//PjQBkvAkgYLI9/A/zqzcdXAHTiGlPoUJFAXbdJkA==
X-Received: by 2002:a65:448a:: with SMTP id l10mr1671235pgq.53.1560848566859;
        Tue, 18 Jun 2019 02:02:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h12sm4491170pje.12.2019.06.18.02.02.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:02:46 -0700 (PDT)
Date:   Tue, 18 Jun 2019 17:02:38 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611153916.13360-2-amir73il@gmail.com>
User-Agent: NeoMutt/20180716-1844-e630b3
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> Depending on filesystem, copying from active swapfile may be allowed,
> just as read from swapfile may be allowed.

...snip..

> +# This is a regression test for kernel commit:
> +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")

Would you mind updating sha1 after it get merged to Linus tree?

That would be helpful for people tracking this issue.

Thanks,
Murphy

>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> @@ -46,7 +49,6 @@ echo swap files return ETXTBUSY
>  _format_swapfile $SCRATCH_MNT/swapfile 16m
>  swapon $SCRATCH_MNT/swapfile
>  $XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/file" $SCRATCH_MNT/swapfile
> -$XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/swapfile" $SCRATCH_MNT/copy
>  swapoff $SCRATCH_MNT/swapfile
>  
>  # success, all done
> diff --git a/tests/generic/554.out b/tests/generic/554.out
> index ffaa7b0a..19385a05 100644
> --- a/tests/generic/554.out
> +++ b/tests/generic/554.out
> @@ -1,4 +1,3 @@
>  QA output created by 554
>  swap files return ETXTBUSY
>  copy_range: Text file busy
> -copy_range: Text file busy
> -- 
> 2.17.1
> 
