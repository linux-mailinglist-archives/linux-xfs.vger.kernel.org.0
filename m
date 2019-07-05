Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C94E60BD7
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfGETmF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 15:42:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40513 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 15:42:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so4620786wrl.7;
        Fri, 05 Jul 2019 12:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=ioFk1N6g9cwoQ8yC3QOjdvEFHxBU0MJBAfDqScTONC8=;
        b=gj4Gpztn3g/T/xueWAjXvbLnJrD4kmjQngQvRcwTbIV0UTSYpABFLtlBnLoJIUPzTs
         pcVCOuUzDpYF7gBMdBDxuXmGC7H/wuxMbCJrEG5lfqhro0ljJiEnEgg9U3XtI9NOU9sY
         drUAheT61dEOpLAW7N0V2Wq2+43A3UbJ9v3BuVlSUvHUdYUOXWS7tOe98sZjH5rr6K+5
         qLE7D/Aw+zxaSzMCluJIMXin8h+I4AVAcAAjSNaxArNvi0x0/9OSi6ybAUnJFBMt1DRl
         ZFdvG0F2lOO2teqO6X2CJ7PmaPp25JTkOPwmupz2PW5KrhBKt2eyqS8xM9kuCCOky1pc
         E/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ioFk1N6g9cwoQ8yC3QOjdvEFHxBU0MJBAfDqScTONC8=;
        b=AXJuYFAx1+Nxlq1EQhBvAiEkkwwOl5/Ev1/4OBSdkf8dFaug+hIqNUK4K5UHmh7tty
         1kCKlvfhS8GUlcgl+/p47Y+oeig2ozMAbYHlja+d4VyKFklIJibV02mqchIsBhBR8jNE
         ulapprC65Z/Nm/uD+gu+w0Wqh19c6iotVeyYRSlTPUIkaF3mDazjhiWPt6phptBgR4Ox
         mhXVpEjo6DukQODFHYVp4wlkDEaF+b6UR/xxRf6zQ3/THyfIUieLDitwApEyq7OjocYX
         9ohYta888lkvNhK9sB6+n0mC3kjpSzlLCUAuPwZFmXGtLFvwKqZxO+REucK9p8kq92RO
         BlZg==
X-Gm-Message-State: APjAAAXk74wisyMrFQU1H4ilvv6gilI9uSaqJWzYBa6k7wesp0wgXRfM
        fH8KkMXteWKqVBHWnMBoTy0=
X-Google-Smtp-Source: APXvYqxVkAsF8Kd92fOfQHNzLlhoHAX1b5SCewhmJNEtpVAW/UorUxBaC0939OF+n384bJjgQM1qNw==
X-Received: by 2002:a5d:4806:: with SMTP id l6mr1243086wrq.234.1562355723332;
        Fri, 05 Jul 2019 12:42:03 -0700 (PDT)
Received: from localhost ([41.220.75.172])
        by smtp.gmail.com with ESMTPSA id t24sm6023936wmj.14.2019.07.05.12.42.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 12:42:02 -0700 (PDT)
From:   Sheriff Esseson <sheriffesseson@gmail.com>
X-Google-Original-From: Sheriff Esseson <s.esseson@outlook.com>
Date:   Fri, 5 Jul 2019 20:41:48 +0100
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to
 admin-guide
Message-ID: <20190705193329.GA20933@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705190412.GB32320@bombadil.infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 12:04:12PM -0700, Matthew Wilcox wrote:
> On Fri, Jul 05, 2019 at 02:14:46PM +0100, Sheriff Esseson wrote:
> > As suggested by Matthew Wilcox, xfs.txt is primarily a guide on available
> > options when setting up an XFS. This makes it appropriate to be placed under
> > the admin-guide tree.
> > 
> > Thus, move xfs.txt to admin-guide and fix broken references.
> 
> What happened to the conversion to xfs.rst?

Okay, I was thinking placing the file properly should come first before the
conversion.

I'll continue work on the conversion right away. I'll send it on Monday, letting
the dust settle on this one.
 
> 
> _______________________________________________
> Linux-kernel-mentees mailing list
> Linux-kernel-mentees@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-kernel-mentees


 thanks.
