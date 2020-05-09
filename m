Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2361CC2C5
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEIQgS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 12:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEIQgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:36:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B33C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 09:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dSMuqF/cI4p4GjP4WYAws0EN1J+ef6lgYzHEus+MhUo=; b=p2rDAHySucObDZJsEME5Ch3hDA
        fuwgUg+BQ50S4gHmHSeEeadE10gQtmbhbyqBooL0j7Zawdhc9P/FUIN+E5iI13lQZ/117bv6HBAr0
        q1mNk/gQpkigeWLTv4VaqgU0ENB0RqRZavwhyia+rSW3sgPFTJdKig6Zczgq0oU8uiz3eBE2tv4El
        OCIwvQmb8KpsefbqqRANoRApwkVVBYYAamwwI++mOB3MasLk6TqzgxEFg4JGfWLJcVqMrnJAON0UY
        kMbKM/+FBNPypjdXf3taiB77+X807XU+t9HM77OgRSkvbF+e43ILSm3oiYIzMKrrTwJVfqiD7M5CC
        +Wkpsheg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSSF-0008Gj-Hg; Sat, 09 May 2020 16:35:59 +0000
Date:   Sat, 9 May 2020 09:35:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: fix the warning message in xfs_validate_sb_common()
Message-ID: <20200509163559.GA23078@infradead.org>
References: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:59:47PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The warning message should be PQUOTA/GQUOTA_{ENFD|CHKD} can't along
> with superblock earlier than version 5, so fix it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
