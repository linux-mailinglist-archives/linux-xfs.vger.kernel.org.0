Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25649D80
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 11:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfFRJgV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 05:36:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34291 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729220AbfFRJgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 05:36:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so7391309pgn.1;
        Tue, 18 Jun 2019 02:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wPIcBiybH15WRz0cMq8tFzdYCwwx8gzBHPlaP3gzNHQ=;
        b=MCZwQsAvw+E07PLYQweNk2Mgq3ZNMe/uDg/ecUvyg+qufnWAr80TSeVwlWdOzt0cT1
         9C7oNIvNr6mU6jPa1PK0B6wIIeF0ksQDy3EL3WKv/VoAUxcf27r0672Z1WmVmIi08P43
         MA4Ye62jLC603KtiIuVFzpsc4wCQ6s5lAkyRLfYG4giYb8YQtFqg4q3yC0FzQFn+nchg
         T3AV/TaptLBfAPKghbYsbZeNwWqCw4OiQ64mzRkvJAcWj3g5TX/OlGnV1QkqWbqxAkRY
         8Cq/Jh5pGD75Ou2jl5XzR7BPFL9fW4dN3eEUDPTM9oqVgmw0NXCt94eFLxw54WpPIrgb
         f2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wPIcBiybH15WRz0cMq8tFzdYCwwx8gzBHPlaP3gzNHQ=;
        b=Bz2Wp+7I2UImIZPUzZccNquFe+tO0V8aHCOw2bI66mQztQtsiC7E7i677PhR0tpsuC
         7b7SetkBqyJgsqSZ1Y3/zNWDsezZxvZHfgvi9WfVRFd0KsYLiXdLeT4OXbHEUu8cevIJ
         Yci76KaFzTaExD8aIdSwjjDz2zLag1mEOuZ2RuzfOu4Nc4VrFSd7lsQo1eT8lPqV1+0q
         /w/kPKx0KZZ1aZgj5wtVfT+iQC2uf35XKNDsgI9db6yWwlhmN8mMsO0ATrAtkXE2GYh5
         1dCXPYvTlspkN4igfap/4ub0QP9tlWlPest1RgEPKXisi0dkhG+KwDx+VfhapYRimsgi
         rlsg==
X-Gm-Message-State: APjAAAWEbJZS/pAMoGXYmVIyT8c7xid6OTD0DXYUlyfjZNGV5PZnLTkO
        aSUMD3yrH0iXm2m0R5V35Tw=
X-Google-Smtp-Source: APXvYqxxzoeXxSa2/q4OqlpVNY+VgBOBdu6YJcScEN7lJ/W2ABSXWO8rp8p8Ywx/wnkM1GfBCfl37Q==
X-Received: by 2002:a63:c607:: with SMTP id w7mr1807377pgg.379.1560850579757;
        Tue, 18 Jun 2019 02:36:19 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m16sm24927086pfd.127.2019.06.18.02.36.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:36:19 -0700 (PDT)
Date:   Tue, 18 Jun 2019 17:36:11 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618093611.nq27tmcpjxpwxpw6@XZHOUW.usersys.redhat.com>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
User-Agent: NeoMutt/20180716-1844-e630b3
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> > > Depending on filesystem, copying from active swapfile may be allowed,
> > > just as read from swapfile may be allowed.
> >
> > ...snip..
> >
> > > +# This is a regression test for kernel commit:
> > > +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
> >
> > Would you mind updating sha1 after it get merged to Linus tree?
> >
> > That would be helpful for people tracking this issue.
> >
> 
> This is the commit id in linux-next and expected to stay the same
> when the fix is merged to Linus tree for 5.3.

That's perfect. :)

> 
> Thanks,
> Amir.
