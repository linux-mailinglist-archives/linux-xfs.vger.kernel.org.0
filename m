Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A81E894
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOGvd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:51:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55764 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOGvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=bzA52qQ7RgQCoDSs9v/PM4khZ
        VG2Q9rxdg9h1eF1dIaQP0DW/R9DEpppbi9fUg+Ra/HxwVVmGz2PJpIkUtuo/6EVYyeSy36PJjYwmM
        PzyRfMEOXIVQrMXdX3q3gl8GngFarN6TMVuDf29udu7ZdRSmxAXH5iWym8LlraBNJGDLTp4M/A3Cp
        mnlXtYEe1Oo42j/yD0wmfsbAwdT2eL+Mro03ge74W4Hbpp6FDihM+h3V90BDTEQWqmboQ0jyNzbLp
        fcYOgFLQ78T4Fd8YnYD1qa5jFD7biEvUo0X87PMbskF1d/epW9T2hunnTUKNXtneoji5trtlfCeIt
        4+WW5Xdiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnlE-0000Ri-UG; Wed, 15 May 2019 06:51:32 +0000
Date:   Tue, 14 May 2019 23:51:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] libxfs: rename bp_transp to b_transp in ASSERTs
Message-ID: <20190515065132.GD29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-5-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
