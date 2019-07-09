Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AC86376A
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGIOFn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 10:05:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGIOFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 10:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A0ccmHFKAAaiA1+Y+eCDLJWvS9OEhV/u6H9iE/GlQqM=; b=CYpemY3niCxoBnErA3IHfJvT6
        a5647ukYl45yoqDLPlByZdvDPFKMvbBLr9jDOEL3gQ0zZ/q1C3FtwQTTp6ie72pOB9cbTVD81bxPT
        tC5sT7HDHzSGAzo6sIabv7CnIvY4q4bN4DzPhKXFhmEdLis92ozBxtUKlBXnc0mWNaqw/6h9FdaA7
        /I6Wm3R23hUvu31aLxlr6cZ1EcamTNIKXTykUCWPrKG59DaRuck+zNxeTvPNhoOkgL8cJwT9iIUAo
        LP1s7078kJ9G3ORPUnIrNV7rW8qKwh6Mkkli0Db8jJ9H04yFdLo+WqKM+mSNOH7RN0tNF6KTM/GXA
        Af+1dIN3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hkqkW-0004ec-Jv; Tue, 09 Jul 2019 14:05:40 +0000
Date:   Tue, 9 Jul 2019 07:05:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [linux-kernel-mentees] [PATCH v6] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190709140540.GA13183@infradead.org>
References: <20190709124859.GA21503@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709124859.GA21503@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 01:48:59PM +0100, Sheriff Esseson wrote:
> Convert xfs.txt to ReST, rename and fix broken references, consequently.

The subject line still uses completely b0rked naming conventions.
