Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086B11C0F17
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 10:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgEAIDj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 04:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAIDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:03:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEABFC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uzdvw8gVwqhVns4zeK9EsFuMiYfGihFSMNr32cwG9/I=; b=laOjvUAfyQl561R0bcUByMSQdn
        z+1HcPS+EBvYHYmIDW8WdrA6PCHEDP6wX2XjNDCZkgxaUQFEw+HvHHj6u7Z/pFt4ZhLw5r7EjVO81
        zzR1gdcdZudrzrCCK8AYJS3xWAqLHH0g3pv0gufzYNYHyV3H5we0Recq/l8xHUuFS9YvWWaKB5beq
        lEJ3BYJMyARN/W5LSVvbsJ1KlnBKur9S59GkQWFIoEvIE//D6C7XzTvUVkKlAD/yEdCS3HrGxXZzD
        JHdloZP9ULBtlK7KU2qc4XyNilPj2jWg2QXGcyADyRapLe+OxxfWQV+lAgpEEDGi2RAvBCiCCBQx6
        YXG5f2ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQdt-0004a7-HC; Fri, 01 May 2020 08:03:29 +0000
Date:   Fri, 1 May 2020 01:03:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 17/17] xfs: remove unused iget_flags param from
 xfs_imap_to_bp()
Message-ID: <20200501080329.GK29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-18-bfoster@redhat.com>
 <20200430190057.GR6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430190057.GR6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 12:00:57PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 01:21:53PM -0400, Brian Foster wrote:
> > iget_flags is unused in xfs_imap_to_bp(). Remove the parameter and
> > fix up the callers.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Not sure why this is in this series, but as a small cleanup it makes
> sense anyway...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(I'm about to post a series where it would fit in :))
