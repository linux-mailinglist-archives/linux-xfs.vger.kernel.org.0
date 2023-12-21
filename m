Return-Path: <linux-xfs+bounces-1044-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F65D81B6C9
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Dec 2023 14:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C760282920
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Dec 2023 13:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5ED745C9;
	Thu, 21 Dec 2023 12:57:20 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C33697A0;
	Thu, 21 Dec 2023 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEB9768B05; Thu, 21 Dec 2023 13:57:13 +0100 (CET)
Date: Thu, 21 Dec 2023 13:57:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
	ming.lei@redhat.com, jaswin@linux.ibm.com, bvanassche@acm.org
Subject: Re: [PATCH v2 00/16] block atomic writes
Message-ID: <20231221125713.GA24013@lst.de>
References: <c729b03c-b1d1-4458-9983-113f8cd752cd@oracle.com> <20231219051456.GB3964019@frogsfrogsfrogs> <20231219052121.GA338@lst.de> <76c85021-dd9e-49e3-80e3-25a17c7ca455@oracle.com> <20231219151759.GA4468@lst.de> <fff50006-ccd2-4944-ba32-84cbb2dbd1f4@oracle.com> <20231221065031.GA25778@lst.de> <b60e39ce-04bf-4ff9-8879-d9e0cf5d84bd@oracle.com> <20231221121925.GB17956@lst.de> <df2b6c6e-6415-489d-be19-7e2217f79098@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df2b6c6e-6415-489d-be19-7e2217f79098@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 21, 2023 at 12:48:24PM +0000, John Garry wrote:
>>> - ubuf / iovecs need to be PAGE-aligned
>>> - each iovec needs to be length of multiple of atomic_write_unit_min. If
>>> total length > PAGE_SIZE, each iovec also needs to be a multiple of
>>> PAGE_SIZE.
>>>
>>> I'd rather something simpler. Maybe it's ok.
>> If we decided to not support atomic writes on anything setting a virt
>> boundary we don't have to care about the alignment of each vector,
>
> ok, I think that alignment is not so important, but we still need to 
> consider a minimum length per iovec, such that we will always be able to 
> fit a write of length atomic_write_unit_max in a bio.

I don't think you man a minim length per iovec for that, but a maximum
number of iovecs instead.  For SGL-capable devices that would be
BIO_MAX_VECS, otherwise 1.

