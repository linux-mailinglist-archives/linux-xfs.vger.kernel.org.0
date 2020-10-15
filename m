Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176AD28EE72
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgJOI3J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgJOI3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:29:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55658C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WAmC4TFlBTPqMGYFtI1mO3HQTZCtVMpXF5LVE5P7VG8=; b=ta0A9ghH49u3tGNh/9QKVihH+7
        VOebwRmdzeIk9fopFEJtyVllp5gAFrZJ4E+wH3BSGffUtVdmD2atOFhNPuCKJWbU8GPITFoUh0yF2
        UWDM8/nNo5YccANO5+Nj2Kq5EzUOZtOQKwq1DxfVcLmDDSM9Thtui7hqojLK7WbLTmGph8JcnuuDN
        6aE/AuBikBjDNXJVJO2mex7JmBRj8Qt2OskZMN9MPsicaWLhtJWnLuaVft9tQakpkVH98uHykfu2a
        iBTwMNLb0AdcZuXumW9xzBDvcncX6e8TF/9gu3CJ2CWxEZO/GP20ivT2e5tL6r1Wgk+Fl1GJjOmbs
        csEOdvpw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSydE-0001KG-Kr; Thu, 15 Oct 2020 08:29:04 +0000
Date:   Thu, 15 Oct 2020 09:29:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libhandle: fix potential unterminated string problem
Message-ID: <20201015082904.GC4450@infradead.org>
References: <20201008035834.GB6535@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008035834.GB6535@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 08:58:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> gcc 10.2 complains about the strncpy call here, since it's possible that
> the source string is so long that the fspath inside the fdhash structure
> will end up without a null terminator.  Work around strncpy braindamage
> yet again by forcing the string to be terminated properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> Unless this is supposed to be a memcpy?  But it doesn't look like it.

No, it should not be memcy, and the change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

That being said path_to_fspath where fspath originates is horrible
and not mutlithreading safe due to the static filename buffer.
