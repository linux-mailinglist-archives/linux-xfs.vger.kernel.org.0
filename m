Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E841A255
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 19:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfEJReO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 13:34:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbfEJReN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OcMxWVovI9kKQJcqscuGwJe+NwQ9Yl2HVG1SObiT894=; b=J8rW7nlmcO3LfYXYcLc0vdKp2
        L7aeEn9RM6YsEad9xd+E4mbb1PtDopzYzLaSuW+QPIkgwle/+hmRO2m2Cd9GMzDOD0NZ47Sm5xPyG
        S8S/jLA8KMp8qBGIkeWFQQbqMdM7KesP20QgjlvjOYsbXcl9PtSCxpjNMqcXOiDFaDEyfXKx4tehO
        omSGnUmg5W9dlgE4wwqo/FuiyXBoU8aBHEprAS9q37nRxLKxSIuTsdhDIbIziRg+y/wwL/kerGnoX
        k/GB7YmqzyLakTsUL/+JIGS5M8rbk7Nj+jwDFvPJXHmpcN1SdI5LdgnJJFyhbk66FBR7MQJOBvYX1
        fbCXSkpQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hP9PR-0000U1-J2; Fri, 10 May 2019 17:34:13 +0000
Date:   Fri, 10 May 2019 10:34:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190510173413.GD18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-6-bfoster@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -724,8 +723,6 @@ xfs_alloc_ag_vextent(
>  	args->wasfromfl = 0;
>  	switch (args->type) {
>  	case XFS_ALLOCTYPE_THIS_AG:
> -		error = xfs_alloc_ag_vextent_size(args);
> -		break;
>  	case XFS_ALLOCTYPE_NEAR_BNO:
>  	case XFS_ALLOCTYPE_THIS_BNO:
>  		error = xfs_alloc_ag_vextent_type(args);
> @@ -817,6 +814,8 @@ xfs_alloc_cur_setup(
>  
>  	if (args->agbno != NULLAGBLOCK)
>  		agbno = args->agbno;
> +	if (args->type == XFS_ALLOCTYPE_THIS_AG)
> +		acur->cur_len += args->alignment - 1;

At this point we can just kill that switch, or even better
merge xfs_alloc_ag_vextent_type and xfs_alloc_ag_vextent.
