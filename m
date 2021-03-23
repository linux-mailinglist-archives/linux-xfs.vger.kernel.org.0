Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D71346399
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Mar 2021 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhCWPv5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 11:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhCWPvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 11:51:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8928C061574;
        Tue, 23 Mar 2021 08:51:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c17so7829401pfn.6;
        Tue, 23 Mar 2021 08:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=t0mivpXIuWwx9gP16IjJs3W87rHyzlNwbyfeEx8As/Y=;
        b=jT7xvHnYN9jm0FJQE0C8NwDDnsO+P/CPOuzPTH/pURNUV2oLz7NmiSfnKv2+vditiK
         b3Fdx7445KH8CH3mXjPTXn6sPExVJ3uNQcxxkactqufL+rkic5LiC5stfqjAcTWUdyua
         9xep6vakVSVlMdneZQFoLHXVqrN+6SGs2y/3Ead4/I5jTIm3cdMxLU3FE8T053jMHz61
         i6nn9llgGdayg+NLDfFOw56uCCxAA9W6Z6gnslP4GwwGXvpd3fuEbnp85lOCOJG9VVwa
         B6JRNnQ35X3L1dnyLu2GnCS6rCemeD+rpPRJgJU+0jXAvyAYDm6wDHgC4xsZef921tuS
         epsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=t0mivpXIuWwx9gP16IjJs3W87rHyzlNwbyfeEx8As/Y=;
        b=biG4lGtdiMgVcJeXpHXuTHZs+0GmTef2IHMKysDZZZ2SnO0vX39kmndCC7AUg++BD8
         iONwUf52HYM9fTZGy5/S5tzN0pyUqsHj/ReDVv9zh43Up+Mm/6utZjPRbcAlE3Hww2GJ
         AS5UR2r7X8rn2ojZjSc5BIpMKE2q9bXWQ/0EKCuZifBOB04GgkVt5CnBngs0kf4t26cB
         tmsgKL0IkaPXS53opXCLMmg51MlyPVW0ZU+TS47keSFUUfmlVUQ+GTQUFdhL8QL8wXcM
         SLNehVHNLHmDsL8aVyusWG73Qw9CMtHyi4Swj8xrVyYqmq+NNYu/Sep15UeY7/DzB1/8
         9uDg==
X-Gm-Message-State: AOAM532nIF8BMkKTAnvAaYSbgSOB6FM+fZP77eLhGpboKHi/Ox2NqUZy
        tpNamZ0N37550JxnCJbqPm68Uri9dfk=
X-Google-Smtp-Source: ABdhPJyUgp1p94yLGBUJbQxPyaAVfxaCVm5Y4Adga5HNMGqaNgtSq5t+k9UTdR7AgYzTOvkXOrQrOg==
X-Received: by 2002:a17:902:b088:b029:e6:e1d8:20cc with SMTP id p8-20020a170902b088b02900e6e1d820ccmr6271228plr.27.1616514691104;
        Tue, 23 Mar 2021 08:51:31 -0700 (PDT)
Received: from garuda ([122.179.41.147])
        by smtp.gmail.com with ESMTPSA id s12sm15114920pgj.70.2021.03.23.08.51.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Mar 2021 08:51:30 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-6-chandanrlinux@gmail.com> <20210322175652.GG1670408@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
In-reply-to: <20210322175652.GG1670408@magnolia>
Date:   Tue, 23 Mar 2021 21:21:27 +0530
Message-ID: <87r1k56f7k.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22 Mar 2021 at 23:26, Darrick J. Wong wrote:
> On Tue, Mar 09, 2021 at 10:31:16AM +0530, Chandan Babu R wrote:
>> Verify that XFS does not cause realtime bitmap/summary inode fork's
>> extent count to overflow when growing the realtime volume associated
>> with a filesystem.
>>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>
> Soo... I discovered that this test doesn't pass with multiblock
> directories:

Thanks for the bug report and the description of the corresponding solution. I
am fixing the tests and will soon post corresponding patches to the mailing
list.

--
chandan
