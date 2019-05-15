Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E234E1E899
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfEOGwR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:52:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOGwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bUfFHzhhXpCcexNasc2aylEf2f/UKCuFyxjrxhFiNHE=; b=LcljWIqqxySq2gYLSyjbV9lQx
        OxDppnagg9iEYTgVAnbeB/Xqwbvt4BgCfHknC7VT/tC9nPLQCBoNnKijhdYnrYQ0Eg+bskce9c7ES
        Wv74SBYMo3jIwEr7GrdtPi05nd7/z0K657I/iEPxBlLdZsl9LnFLHrnF8y26jMXIHqXXp2LgVk27L
        mvOlGVbpPx1qWVjL0z6BAIoCNk0zd2SKG9xKa8pfIh/EljeXrNEv7p84Z5y5gCeXlHIlKq0wikepv
        inB0DHMa4uWFP8XgnE8Wfv9ZMu6XDL5qNwFumJBMBWZMqATduKmnJA9itUcORjO3Awv+h8kLLT976
        UzqRkcgwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnlv-0000rt-LR; Wed, 15 May 2019 06:52:15 +0000
Date:   Tue, 14 May 2019 23:52:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] libxfs: de-libxfsify core(-ish) functions.
Message-ID: <20190515065215.GE29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-6-git-send-email-sandeen@redhat.com>
 <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 04:41:03PM -0500, Eric Sandeen wrote:
> On 5/10/19 3:18 PM, Eric Sandeen wrote:
> > There are a ton of "libxfs_" prefixed functions in libxfs/trans.c which
> > are only called internally by code in libxfs/ - As I understand it,
> > these should probably be just "xfs_" functions, and indeed many
> > of them have counterparts in the kernel libxfs/ code.  This is one
> > small step towards better sync-up of some of the misc libxfs/*
> > transaction code with kernel code.
> 
> I should have changed internal callers too, will resend after other
> review.

I have to admit I never got this whole libxfs renaming.  Why can't
we just use the xfs_* namespace for libxfs as well to start with?
