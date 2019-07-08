Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81062A06
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 21:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfGHT7H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 15:59:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbfGHT7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 15:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ilP8aKND5J/0FqwOuE2M9iHuTp8wkZ8Ej53ocwpDD5A=; b=OlJFwXxcq+ZUJ7PWk7/2A5ZHb
        3bGGjiG0Mom0f4MkLNUp9pAJ/dD7aRRwVTE86cilWagEocpLvF39BTymfL0XWttm8HSnzUxonYZ+X
        7Tfrsb7LiJJkcD9AN8AivNzMuu7QLnuuD/XrySzC3/QWgsZLjYYTkZAoztBtC/e61VOFf2WdB4n5C
        jU0JnRsfCqZ+QZ78oEL4k8H7jcoHhtStaLIHnWV0rgNLXqSsDjm6LC1NuWsWGO2T7yNWK/haonkH2
        rvzzcAFahBQoQ8S3vbAdjUQAQipYRsCuXwO6vXIqqL2quflC2bwnlWQej3H8ZiJvNDSVP/040J+Qw
        EqXAnDmnQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hkZn0-00028B-R1; Mon, 08 Jul 2019 19:59:06 +0000
Date:   Mon, 8 Jul 2019 12:59:06 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH] Doc : fs : move xfs.txt to
 admin-guide
Message-ID: <20190708195906.GH32320@bombadil.infradead.org>
References: <20190705190412.GB32320@bombadil.infradead.org>
 <20190705193329.GA20933@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705193329.GA20933@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 08:41:48PM +0100, Sheriff Esseson wrote:
> On Fri, Jul 05, 2019 at 12:04:12PM -0700, Matthew Wilcox wrote:
> > On Fri, Jul 05, 2019 at 02:14:46PM +0100, Sheriff Esseson wrote:
> > > As suggested by Matthew Wilcox, xfs.txt is primarily a guide on available
> > > options when setting up an XFS. This makes it appropriate to be placed under
> > > the admin-guide tree.
> > > 
> > > Thus, move xfs.txt to admin-guide and fix broken references.
> > 
> > What happened to the conversion to xfs.rst?
> 
> Okay, I was thinking placing the file properly should come first before the
> conversion.

But if you move it, then rename it, you have to change all these places
again.  The minimal conversion you did the first time was quite a nice diff
to read.
