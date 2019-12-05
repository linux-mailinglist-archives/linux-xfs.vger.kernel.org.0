Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62E3113C7E
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Dec 2019 08:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfLEHoh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Dec 2019 02:44:37 -0500
Received: from verein.lst.de ([213.95.11.211]:53845 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfLEHoh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Dec 2019 02:44:37 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 470D268BFE; Thu,  5 Dec 2019 08:44:35 +0100 (CET)
Date:   Thu, 5 Dec 2019 08:44:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        jstancek@redhat.com
Subject: Re: [PATCH] xfs: fix sub-page uptodate handling
Message-ID: <20191205074435.GA19505@lst.de>
References: <20191204172804.6589-1-hch@lst.de> <20191204215706.GT7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204215706.GT7335@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, the subject should say iomap instead of xfs, sorry.
