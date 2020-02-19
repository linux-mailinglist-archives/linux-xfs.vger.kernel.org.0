Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2472164729
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2020 15:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgBSOi2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Feb 2020 09:38:28 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:52071 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgBSOi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 09:38:28 -0500
Received: by mail-pj1-f48.google.com with SMTP id fa20so168615pjb.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 06:38:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=72WkHNZNBug+h8xnQErZ09ASCGeIduOZsTbS42xwNo8=;
        b=LKFrFCt4iFIXdX9dyC69SQ1J2d1E+E6jgxJQEGzvonIcuiOYkcjFEmCBeFz5gZrvv+
         OMXGE1kPJJmkw9fwmzFYANtZ77Mpp+2sulp7dmvidO4BVCs5owyGaSy0kPNgxgKVmaB/
         6udmQswVluNd9EcQg3O+YOQ0hBeRxGtHcfvmuOav8JIEpn5sD0ilGq847+yJsIC8yd0m
         Cj0buda+wDxtxCvARoVyh/vL8QvV3XdfxhQncE3lAmXZWQ1fXn3xm3TTD/PBRPwuu8T9
         VHraIDhDFC40T/MVFNr+USFQik5dn2laOpLVqRQXnUrQ4PHkIDzirLqkB9ahjjghE9/b
         Du3A==
X-Gm-Message-State: APjAAAUkEHo1LI4CJZfI+3/xpxHGW3i+D8GvS8huDCRRAIyWBKZepDRG
        9dHsgx1ElD15HkoSmsc4aDQ=
X-Google-Smtp-Source: APXvYqwKUrLByyjeDu8w3vggFrqS0WOYuHDGvo2J2iAO07KfjwzEb8qyASxqaYm1DjR72zAEwjj1oA==
X-Received: by 2002:a17:902:bf41:: with SMTP id u1mr25796854pls.207.1582123106607;
        Wed, 19 Feb 2020 06:38:26 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g21sm3651679pfb.126.2020.02.19.06.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 06:38:25 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 91334402D7; Wed, 19 Feb 2020 14:38:24 +0000 (UTC)
Date:   Wed, 19 Feb 2020 14:38:24 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219143824.GR11244@42.do-not-panic.com>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219143227.aavgzkbuazttpwky@andromeda>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > actual modern typical use case for it. I thought this was somewhat
> > realted to DAX use but upon a quick code inspection I see direct
> > realtionship.
> 
> Hm, not sure if there is any other use other than it's original purpose of
> reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> probably raised more questions than answers to yours :P

What about another question, this would certainly drive the users out of
the corners: can we remove it upstream?

  Luis
