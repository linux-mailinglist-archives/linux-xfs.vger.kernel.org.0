Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F357395A8
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jun 2023 04:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjFVC6Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Jun 2023 22:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjFVC6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 22:58:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CE1BD6
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 19:58:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b4f9583404so50750475ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 19:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687402692; x=1689994692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m/KvQWXAOHldExG4iarYTqEAz3JkjW/lRf6vdePGYWE=;
        b=Mf2WV+sjMEN/LaPtz+qNtCSNeNqLiIQDSjnubCxXVytDaytURAqud4QUn7fJ806TSf
         xKb6xyNeuu+6ggbyprWxJfpnstHwfazjddmAFZwstD7ZGnr0DqCVrK77CeFUxWfcUKAc
         bMvsR02Urwh1LG4IX2urhz01C3L5K3U2DbPUqlLHm4vCwH2e0hD9Fj44fTkjFCgEU0cr
         0xr/jME9e3fXRCXHVrk1nmQH6NSBptW+SKKKpzpHS07S1Kp+02EgkVZYA3BzG6Qv0WyV
         QkIaBp2QnXxGbaH0/ZbJbucWrW3tNLcK+hB2uV8lGxySoVo3bL0DarkBvwNFonr0W46r
         94lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687402692; x=1689994692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/KvQWXAOHldExG4iarYTqEAz3JkjW/lRf6vdePGYWE=;
        b=MjFasy4onDLHoiIK6dDz0VOfOSLOneMRuwZNk8iAjdqbKadRi41EO1xqmufkM4gbrI
         1de4khxMqDUr89jAOBQBk8rqdzH3LxWwITyGlcknOFV1I5KpnDHpIbsCHceDf1m+F22/
         nQ6oOnEJ7c4uaw3UloHOYJS4IP03i4w/y8/ReC13OtYXKvCnf2esrr9QRLMdy4OHoJh9
         8Sg8aEDWknUqrocOofhOiz6YYxyiOyAwOkfor6kHv/E/EVRMdT6x3yVsOpE79A/7re9R
         yIg1G3XZp4l6m+a1ITWSqi+S5arMjawbHjYOm+FTmoFQi2HyglIVnsavwxaIZMVT52Ru
         v1ig==
X-Gm-Message-State: AC+VfDwRcG0CkqT3ovN2UpKYijLuaYj4YKGsbUBdONK5dgzlVj2Bjpwi
        tCYifLlUxISytAa+yL5Jt+zzTLXysbLLddy+d+E=
X-Google-Smtp-Source: ACHHUZ7GmljNTm7ImrozRM1RFXnFcabacaWqZvPh5jY/QBXdJku6IY90C62HLFbDPah9rbOq17pS1A==
X-Received: by 2002:a17:902:ef8c:b0:1af:b92d:b5fe with SMTP id iz12-20020a170902ef8c00b001afb92db5femr16912373plb.0.1687402691969;
        Wed, 21 Jun 2023 19:58:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902a60d00b001ae0a4b1d3fsm4174996plq.153.2023.06.21.19.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 19:58:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCAWO-00Egjy-26;
        Thu, 22 Jun 2023 12:58:08 +1000
Date:   Thu, 22 Jun 2023 12:58:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, willy@infradead.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET v25.0 0/7] xfs: stage repair information in pageable
 memory
Message-ID: <ZJO4wDMYEdaA0zc4@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506056447.3729324.13624212283929857624.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506056447.3729324.13624212283929857624.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:28:55PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> In general, online repair of an indexed record set walks the filesystem
> looking for records.  These records are sorted and bulk-loaded into a
> new btree.  To make this happen without pinning gigabytes of metadata in
> memory, first create an abstraction ('xfile') of memfd files so that
> kernel code can access paged memory, and then an array abstraction
> ('xfarray') based on xfiles so that online repair can create an array of
> new records without pinning memory.
> 
> These two data storage abstractions are critical for repair of space
> metadata -- the memory used is pageable, which helps us avoid pinning
> kernel memory and driving OOM problems; and they are byte-accessible
> enough that we can use them like (very slow and programmatic) memory
> buffers.
> 
> Later patchsets will build on this functionality to provide blob storage
> and btrees.

Apart from the need for a struct xfs-mount just for the xfile name
at creation time, this all looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Is there any specific test harness for this infrastructure, or is it
just validated by having other functions built on top of it "work
correctly"?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
