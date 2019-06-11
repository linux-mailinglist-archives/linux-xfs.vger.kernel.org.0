Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA423C558
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 09:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbfFKHpq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 03:45:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404300AbfFKHpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 03:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WHtxP8N3XgRYBj6YozMGpGmfQA80TnYyR9VzDSZSHEU=; b=oZ4r4qVbVEHvNhm4ZphvxJKif
        2P1yYEh69pfuFTmJ6OfwKxVtYcpFD0KMnpbS30mTyn+CJIQB/39Hr4UEksEF970wtuvUo9OG1V6cc
        KLm5FtAD4PHELw6T6xxwb0P2AI7ik5uR2bcl/VLG8aqvTZlXjt7Cp6wVVneR8GUdLU8r3qmcG0Mlw
        Avv3pFFzhYBeLICHBTIvlakqmjb2QaVh7L+VabEJCp6iU48yc8bUm4y2bMYHHtAlQ0UtU+zM6zl3g
        yOH/jLso6nbbTX12INTsO9HAeTZ6LgvljxhHNvnCCBbfZN4l78p9PbRTGzaxvsfIS3TMnAjamMG9d
        4RqdfKWAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1habTR-0001Z8-CK; Tue, 11 Jun 2019 07:45:41 +0000
Date:   Tue, 11 Jun 2019 00:45:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH V2 0/2] block: fix page leak by merging to same page
Message-ID: <20190611074541.GA31787@infradead.org>
References: <20190610041819.11575-1-ming.lei@redhat.com>
 <20190610133446.GA28712@infradead.org>
 <20190610150958.GA29607@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610150958.GA29607@ming.t460p>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can you please trim your replies?  I've scrolled two patches before
giving up trying to read your mail.
